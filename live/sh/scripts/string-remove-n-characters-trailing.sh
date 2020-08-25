#!/usr/bin/env  sh



#DEBUG='true'



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  2  'example'
  # =>
  # examp
  return
fi



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}



string_remove_n_characters() {
  number_of_characters_to_remove="$1"
  shift
  # $2*
  string="$*"
  string_length=${#string}
  _debug  "string length:  $string_length"
  string_length_desired=$(( string_length - number_of_characters_to_remove ))
  _debug  "string length desired:  $string_length_desired"
  string-truncate.sh  "$string_length_desired"  "$string"
}



string_remove_n_characters  "$@"
