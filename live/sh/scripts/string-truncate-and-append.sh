#!/usr/bin/env  sh


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  3  '…'  'string'
  return
fi


string_length_maximum="$1"
string_to_append="$2"
shift
shift
# $3*
string="$*"


string_truncate_and_append() {
  __=$( string-truncate.sh  "$string_length_maximum"  "$string" )
  \echo  "$__$string_to_append"
}



string_truncate_and_append  "$string_length_maximum"  "$string_to_append"  "$string"
