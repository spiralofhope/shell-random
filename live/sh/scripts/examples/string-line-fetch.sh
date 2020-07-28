#!/usr/bin/env  sh

# Return a specific string-line from a string-list.


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  2  'one
two
three'
  return
fi


# TODO - ensure this is a number
line_number_desired="$1"
shift
# $2*
string="$*"


string_line_desired() {
  line_number_desired="$1"
  shift
  # $2*
  string="$*"
  #
  i=1
  for line in $string; do
    #\echo  "Processing line number $i"
    if [ "$i" -eq "$line_number_desired" ]; then
      \echo  "$line"
      return
    fi
    i=$(( i + 1 ))
  done
}


string_line_desired  "$line_number_desired"  "$string"
