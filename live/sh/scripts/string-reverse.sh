#!/usr/bin/env  sh

# Reverse a string.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  'Hello, world'
  # =>
  # dlrow ,olleH
  return
fi


string="$*"


string_reverse() {
  string="$*"
  __="$string"
  while [ -n "$__" ]; do
    string_without_first_character="${__#?}"
    first_character="${__%"$string_without_first_character"}"
    output="$first_character$output"
    __="$string_without_first_character"
  done
  \echo  "$output"
}


string_reverse  \
  "$string"
