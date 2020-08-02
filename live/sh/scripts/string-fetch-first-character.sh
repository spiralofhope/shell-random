#!/usr/bin/env  sh



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  'example'   # =>  e
  #"$0"  'test'      # =>  t
  return
fi


string="$@"


string_fetch_first_character() {
  string="$@"
  # $__ is destroyed while being processed:
  __="$string"
  while [ -n "$__" ]; do
    rest="${__#?}"
    first_character="${__%"$rest"}"
    printf  '%s'  "$first_character"
    return
  done
}



string_fetch_first_character  "$string"
