# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
HISTCONTROL=ignoreboth
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

export PAGER=less

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PATHs
export PATH=$PATH:~/.bin/
#export PATH=~/perl5/bin/:$PATH
#export PATH=$HOME/go/go1.13/go/bin:$PATH:~/.bin
#export PATH=$HOME/.gem/ruby/2.5.0/bin:$PATH
#export GPATH=$HOME/go/go1.13/go

# sources
#source ~/perl5/perlbrew/etc/bashrc
#source pyenv/bin/activate

# exports
export EDITOR=vim
# # See: http://wiki.bash-hackers.org/scripting/debuggingtips#making_xtrace_more_useful
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
#export PERL5LIB=lib:$PERL5LIB

# evals
#eval "$(pyenv virtualenv-init -)"

# sets
set -o vi
#set bell-style none # typically I disable this in the shell emulator

### Colors
#[Note: Replace 0 with 1 for dark color - or bold]
black="\[\033[0;30m\]"
blue="\[\033[0;34m\]"
green="\[\033[0;32m\]"
cyan="\[\033[0;36m\]"
red="\[\033[0;31m\]"
purple="\[\033[0;35m\]"
yellow="\[\033[0;33m\]"
boldyellow="\[\033[1;33m\]"
no_color="\[\033[0m\]"

case "$HOSTNAME" in
    aka64) color=$green;;
    akayo) color=$boldyellow;;
    *) color=$purple;;
esac

bash_prompt() {
  gitrepo="$(git rev-parse --show-toplevel 2>/dev/null)"
  psbr=""
  #[ $UID -eq "0" ] && UP="#"    # root's prompt
  #local UC=$color              # user's color
  #local UP="$"                  # user prompt
  #PS1="${UC}\t \u@\h:\w$NORMAL ${psbr}$UC\# ${UP}>$NORMAL "
  if [ -z "$gitrepo" ]; then
    PS1="\A \$? $color\u$no_color@\h: \w ${psbr}$color\\$ $no_color"
  else
    gitrepo=$(basename $gitrepo)
    br=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    psbr=""
    if [ ! -z "$br" ]; then
        if [ "$br" = 'master' ]; then
            psbr="($red$br$no_color) "
        elif [ "$br" = 'integration' ]; then
            psbr="($purple$br$no_color) "
        else
            psbr="($green$br$no_color) "
        fi
    fi
    PS1="\A \$? $color\u$no_color@\h: ${gitrepo}: \W ${psbr}$color\\$ $no_color"
  fi
}
PROMPT_COMMAND=bash_prompt
bash_prompt


# aliases
alias s=ssh
alias vi=vim
alias ls="ls -FC"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias w3m="w3m -v"
alias tmesg='dmesg|perl -ne "BEGIN{\$a= time()- qx!cat /proc/uptime!};s/\[\s*(\d+)\.\d+\]/localtime(\$1 + \$a)/e; print \$_;"'
alias gitcd='cd "$(git rev-parse --show-toplevel)"'
alias svncd='cd "$(svn info | awk -F: "/Working Copy Root Path:/ { print \$2 }" | sed "s/^ //" )"'
alias hgcd='cd "$(hg root)"'
alias reposcd='cd ~/repos/sets/'
alias tf="terraform"
alias tfa="terraform apply"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tws="timew start"
alias tw="timew"
alias ts='tmux_ssh_sess'
alias validate_json='python -mjson.tool <'
alias irc='ssh -t moto ssh -t moto@server screen -rd irc'
alias st='ssh -t moto t'
alias motot='s -t moto t'
alias autossh='AUTOSSH_POLL=15 autossh -M20001 -t p-shsaaa-mgt01 t'

# functions
t(){
    if [ -z "$1" ];
    then
        tmux a -t def || tmux new -s def
    else
       tmux $@
    fi
}

ncal(){
    if [ -z $2 ] && [ -n $1 ]
    then /usr/bin/ncal -w $1 $(date +%Y)
    else /usr/bin/ncal -w $*
    fi
}

#s(){
#    while [ -n "$1" ]
#    do
#        host="$1"
#        shift
#        while [[ "$1" =~ ^- ]]
#        do
#            cmd+="$1 $2 "
#            # catch single flags
#            if ! shift 2; then shift 1; fi
#            echo $*
#            echo $cmd
#        done
#        if [ -n "$screentitle" ];
#        then
#            screen -t "$host" ssh "$host" $cmd
#        else
#            ssh "$host" $cmd
#        fi
#        unset host cmd
#    done
#}

#########
# ssh-agent
export_agent(){
    while read line; do ssh_agent+="export $line\n"; done < <(env | grep -E 'SSH_(AGENT|AUTH)' )
    if [ -n "$ssh_agent" ]
    then
        echo -e "$ssh_agent" > ~/.ssh_agent
    fi
    unset ssh_agent
}

import_agent(){
    if [ -r ~/.ssh_agent ]
    then
        . ~/.ssh_agent
    fi
}

if [ -z $SSH_AGENT_PID ]
then
    import_agent
fi

if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null
then
    # try importing agent settings first, in case the parent session has
    # a broken agent but we already started and executed a new ssh-agent
    import_agent
    if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null
    then
        echo "import ssh-agent not found, starting new agent process.."
        eval $(ssh-agent)
        ssh-add ~/.ssh/id_rsa
        export_agent
    fi
fi

mdless(){
    mdcat $1 | less -r
}

gdoc(){
    go doc $* | less
}

# load system specific
if [ "$(uname)" == Darwin ]; then
    source ~/.dotfiles/bashrc_mac
else
    source ~/.dotfiles/bashrc_linux
fi
