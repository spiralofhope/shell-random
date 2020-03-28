#!/usr/bin/env  sh
#
# See https://blog.spiralofhope.com/?p=845


\echo ' * 1 --------'

a="ls -a -l"
eval "$a"

\echo ' * 2 --------'

a="ls"
b="-a -l"
eval "$a" "$b"

\echo ' * 3 --------'

a='ls'
b='-a -l'
# shellcheck disable=2086
$a $b
