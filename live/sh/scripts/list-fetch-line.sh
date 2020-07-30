#!/usr/bin/env  sh

# Fetch a particular line from a list.


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  1  'one
two
three'
  # =>
  # one
  #
  "$0"  3  'one
two
three'
  # =>
  # three
  #
  return
fi



list_fetch_line() {
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


list_fetch_line  "$@"
