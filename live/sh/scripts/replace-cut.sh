#!/usr/bin/env  sh

# Split a string on a single character and output one selected field.

# Thanks to:
#   https://github.com/dylanaraps/pure-sh-bible/#split-a-string-on-a-delimiter

# TODO - Be able to select a range of fields.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  ','  2  apples,oranges,pears,grapes
  # => oranges
  return
fi


# TODO - proper help text.
if [ $# -lt 3 ]; then
  \echo  'requires three or more parameters'
  exit  1
fi



replace_cut() {
  # replace_cut  ','  2  apples,oranges,pears,grapes
  # => oranges
  #
  field_separator="$1"
  field="$2"
  shift
  shift
  text="$*"
  #
  # Disable globbing:
  #   (this ensures that the word-splitting is safe)
  set  -f
  old_ifs=$IFS
  # Change the field separator to what we're splitting on:
  IFS=$field_separator
  # Create an argument list splitting at each occurance of '$field_separator':
  # shellcheck disable=2086
  #   This is safe to disable as it just warns against word-splitting which is the behavior we expect.
  set  --  "$text"
  #
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
  #
  # shellcheck disable=2086
  #   I want word splitting:
  output_part_number  "$field"  $text
  IFS=$old_ifs
  # Re-enable globbing:
  set  +f
}



replace_cut  "$@"
