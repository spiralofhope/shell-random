#!/usr/bin/env  sh


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  20  '…'  'this string is too long'
  "$0"  20  '…'  'this string is short'
  return
fi


string_length_maximum="$1"
string_to_append="$2"
shift
shift
# $3*
string="$*"


string_truncate_and_append() {
  string_result=$( string-truncate.sh  "$string_length_maximum"  "$string" )
  if [ ${#string_result} -lt ${#string} ]; then
    string_result="$string_result$string_to_append"
  fi
  \echo  "$string_result"
}



string_truncate_and_append  "$string_length_maximum"  "$string_to_append"  "$string"
