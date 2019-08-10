#!/usr/bin/env  zsh
#
# See https://blog.spiralofhope.com/?p=845



a="ls -a -l"
eval "$a"

\echo '--------------'

a="ls"
b="-a -l"
eval "$a" "$b"

