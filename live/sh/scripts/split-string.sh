#!/usr/bin/env  sh

# Split a string on a character and output one of the items.

# Thanks to:
#   https://github.com/dylanaraps/pure-sh-bible/#split-a-string-on-a-delimiter



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  ','  2  apples,oranges,pears,grapes
  # => oranges
  #"$0"  ','  4  apples,oranges,pears,grapes
  # => grapes
  return
fi


#\echo  "$*"



# TODO - proper help text.
if [ $# -lt 3 ]; then
  \echo  'requires three or more parameters'
  exit  1
fi



# aka "field separator"
character_to_split_on="$1"
which_match_number_to_output="$2"
shift
shift
text="$*"



# Disable globbing.
# This ensures that the word-splitting is safe.
set -f

# Store the current value of 'IFS' so we
# can restore it later.
old_ifs=$IFS

# Change the field separator to what we're
# splitting on.
IFS=$character_to_split_on

# Create an argument list splitting at each
# occurance of '$character_to_split_on'.
#
# This is safe to disable as it just warns against
# word-splitting which is the behavior we expect.
# shellcheck disable=2086
set -- "$text"


output_part_number(){
  number_to_output=$1
  shift
  while [ $# -ne 0 ]; do
    i="$(( i + 1 ))"
    if [ "$i" -eq "$number_to_output" ]; then echo "$1"; break; fi
    #if [ "$i" -eq "$number_to_output" ]; then echo "$i - $1"; break; fi
    shift
  done
}


# I want word splitting:
#   shellcheck disable=2086
output_part_number  "$which_match_number_to_output"  $text



# Restore the value of 'IFS'.
IFS=$old_ifs

# Re-enable globbing.
set +f
