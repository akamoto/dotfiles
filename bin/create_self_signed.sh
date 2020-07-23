#!/bin/bash

echo "requires rewrite"
exit

set -x

if [ $# -eq 1 ]; then
  echo $1
  HOST="$1"
elif [ $# -gt 1 ]; then
  HOST=$1
  shift
  ALT_HOSTS="$@"
  echo "multiple alternative hostnames - generating for $HOST - alt: $ALT_HOSTS"
else
  echo "no HOST parameter"
  exit 1
fi

DOMAIN=k.vu
file=sanconf.conf

if [[ "$HOST" =~ $DOMAIN ]]
then
    CN=$HOST
else
    CN=$HOST.$DOMAIN
fi

echo "using domain ending \"$DOMAIN\""

cat <<EOF > $file
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
C = DE
L = Munich
O = moto@rbfh.de
CN = $CN
[v3_req]
subjectAltName = @alt_names
[alt_names]
EOF

seen=()
for host in $HOST $ALT_HOSTS
do
  # strip everything besides hostname
  host=${host%%\.*}
  for s in ${seen[@]}
  do
    if [[ "$host" == "$s" ]]
    then
      echo "already created alt entries for $host, ignoring"
      continue 2
    fi
  done
  seen+=($host)

  echo DNS.$(( ${#seen[@]}*2-1   )) = $host.$DOMAIN >> $file
  echo DNS.$(( ${#seen[@]}*2 )) = $host >> $file
done


if [ ! -f $CN-key.pem ]; then
  echo "Using the following request data:"
  cat $file
  openssl req -nodes -new -newkey rsa:4096 -sha256 \
      -days 1825 \
      -config $file \
      -keyout $CN-key.pem \
      -out $CN.csr
  openssl req -text -noout -in $CN.csr | head -n 10 | egrep 'Subject|Public'
  read -p "[continue|QUIT]?: " a
  if [ "$a" != "continue" ]; then
    exit 0
  fi
fi

#openssl req -noout -modulus -in $CN.csr | openssl md5
openssl rsa -noout -modulus -in $CN-key.pem | openssl md5

# convert output file from der to pem
if [ -f server ]; then
    echo "found file \"server\" moving to $CN.cer - continuing.."
    mv server $CN.cer
elif [ -f server.cer ];then
    echo "found file \"server.cer\" moving to $CN.cer - continuing.."
fi
if [ -f $CN.cer ]; then
    echo "generating $CN-crt.pem from $CN.cer"
    CN=$(openssl x509 -noout -subject -in $CN.cer -inform der| sed '/^subject/s/^.*CN=//;s/\/.*$//')
    openssl x509 -in $CN.cer -inform der -outform pem -out $CN-crt.pem
fi

if [ -f $CN-crt.pem ]; then
    echo "found $CN-crt.pem - continuing.."
    CN=$(openssl x509 -noout -subject -in $CN-crt.pem| sed '/^subject/s/^.*CN=//;s/\/.*$//')
    if [ "$CN" == "$CN" ]; then
        openssl x509 -noout -modulus -in $CN-crt.pem| openssl md5
    else
        echo
        echo "Error: CN $CN doesn not match filename $CN-crt.pem"
        exit 1
    fi
else
    echo "Missing $CN-crt.pem"
fi

# check remote cert
#echo | openssl s_client -showcerts -servername $CN -connect $HOST:443 2>/dev/null |  openssl x509 -inform pem -noout -text
