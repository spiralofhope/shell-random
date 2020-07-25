#!/usr/bin/env  sh

# Thanks to:
#   https://stackoverflow.com/a/51052644/1190568



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  'string'
  return
fi


string="$1"


__="$string"
while [ -n "$__" ]; do
  # All but the first character of the string
  rest="${__#?}"
  #  Remove $rest, and you're left with the first character
  first_character="${__%"$rest"}"
  echo "$first_character"
  __="$rest"
done
