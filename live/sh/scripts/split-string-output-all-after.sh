#!/usr/bin/env  sh

# Split a string, and output everything after the first match.
# See split-string.sh if you want everything before that match.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  ','  apples,oranges,pears,grapes
  # => oranges,pears,grapes
  return
fi


#\echo  "$*"



# TODO - proper help text.
if [ $# -lt 2 ]; then
  \echo  'requires two or more parameters'
  exit  1
fi



# aka "field separator"
character_to_split_on="$1"
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
    if [ "$i" -eq "$number_to_output" ]; then
      # Restore the value of 'IFS'.
      IFS=$old_ifs
      # Re-enable globbing.
      set  +f
      \echo  "$*"
      break
    fi
    shift
  done
}


# I want word splitting:
#   shellcheck disable=2086
output_part_number  2  $text
