#!/usr/bin/env  sh

# Return a specific character range from a string.
# If the two number are the same, it outputs just the one character.

# TODO - If the range is "negative" then reverse the order of the output.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  3  5  'example'   # =>  amp
  #"$0"  2  3  'example'   # =>  xa
  return
fi


# TODO - ensure this is a number
character_range_desired_begin="$1"
shift
# TODO - ensure this is a number
character_range_desired_end="$1"
shift
# $3*
string="$*"



for i in $( replace-seq.sh  "$character_range_desired_begin"  "$character_range_desired_end" ); do
  output="$output$( string-fetch-character.sh  "$i"  "$string" )"
done
\echo  "$output"
