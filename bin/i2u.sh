#!/bin/sh
# ISO-8859-1 to UTF-8 conversion
iconv --from-code=ISO-8859-1 --to-code=UTF-8 $1
