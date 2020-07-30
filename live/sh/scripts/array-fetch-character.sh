#!/usr/bin/env  sh

# Fetch a specific line and character position from a string-list.
# This is really just a combination of `string-line-fetch.sh` and `string-character-fetch`


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  2  1 'one
two
three'
  # => t
  #
  "$0"  2  2 'one
two
three'
  # => w
  #
  "$0"  1  3 'one
two
three'
  # => e
  #
  return
fi


# TODO - ensure this is a number
line_number_desired="$1"
# TODO - ensure this is a number
character_number_desired="$2"
shift
shift
# $3*
string="$*"


line=$( list-fetch-line.sh  "$line_number_desired"  "$string" )
\echo  $( string-fetch-character.sh  "$character_number_desired"  "$line" )
