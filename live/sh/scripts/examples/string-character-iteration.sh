#!/usr/bin/env  sh

# Thanks to:
#   https://stackoverflow.com/a/51052644/1190568



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  'string'
  return
fi


string="$*"


__="$string"
while [ -n "$__" ]; do
  string_without_first_character="${__#?}"
  first_character="${__%"$string_without_first_character"}"
  \echo  "$first_character"
  __="$string_without_first_character"
done
