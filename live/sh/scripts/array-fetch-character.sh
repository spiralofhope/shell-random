#!/usr/bin/env  sh

# Fetch a specific line and character position from a string-list.
# This is really just a combination of `string-fetch-line.sh` and `string-fetch-character`



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

  # `array-fetch-character.sh; echo $?`
  "$0"  a  3 'one
two
three'
  # => 
  # (returns nothing; exit code 1)

  return
fi



# Sanity-check:
is-string-a-number？.sh  "$1" &&  \
is-string-a-number？.sh  "$2"     \
|| return  1



desired_number__line="$1"
desired_number__character="$2"
shift
shift
# $3*
string="$*"


line=$( list-fetch-line.sh  "$desired_number__line"  "$string" )
\echo  $( string-fetch-character.sh  "$desired_number__character"  "$line" )
