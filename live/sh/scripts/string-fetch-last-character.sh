#!/usr/bin/env  sh

# Return the last character from a string.
# This is a POSIXism for things like:
#   printf  $string | \tail  -c 1


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  'testing'   # =>  g
  #"$0"  '1234'      # =>  4
  return
fi

string="$@"


string_fetch_last_character() {
  length_of_string=${#string}
  last_character="$string"
  i=1
  until [ $i -eq "$length_of_string" ]; do
    #echo $i
    last_character="${last_character#?}"
    i=$(( i + 1 ))
  done

  printf  '%s'  "$last_character"
}
string_fetch_last_character  "$string"
