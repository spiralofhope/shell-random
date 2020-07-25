#!/usr/bin/env  sh


#DEBUG='true'




if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  3  'string'
  return
fi


DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}


string_truncate() {
  string_length_maximum="$1"
  shift
  string="$*"
  string_length=${#string}
  #
  _debug  "String:                   $string"
  _debug  "  String length:          $string_length"
  _debug  "  String length maximum:  $string_length_maximum"
  #
  if [ "$string_length" -le "$string_length_maximum" ]; then
    _debug  "  (not truncating)"
    \echo  "$string"
  else
    # See  `iterate-over-characters-in-a-string.sh`
    __="$string"
    #
    while [ -n "$__" ]; do
      rest="${__#?}"
      first_character="${__%"$rest"}"
      result="$result$first_character"
      __="$rest"
      #
      if [ ${#result} -eq "$string_length_maximum" ]; then
        \echo  "$result"
        break
      fi
    done
    _debug  "  Length is greater than:   $string_length_maximum"
    _debug  "  Truncating string to:     $result"
  fi
}



string=$( string_truncate  "$1"  "$2" )
\echo  "$string"
