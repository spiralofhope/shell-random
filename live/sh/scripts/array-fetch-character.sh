#!/usr/bin/env  sh

# Fetch a specific line and character position from a string-list.
# This is really just a combination of `string-line-fetch.sh` and `string-character-fetch`


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  2  2 'one
two
three'
  # => w
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


string_line_desired() {
  line_number_desired="$1"
  shift
  # $2*
  string="$*"
  #
  i=1
  for line in $string; do
    #\echo  "Processing line number $i"
    if [ "$i" -eq "$line_number_desired" ]; then
      \echo  "$line"
      return
    fi
    i=$(( i + 1 ))
  done
}


string=$( string_line_desired  "$line_number_desired"  "$string" )


string_get_character_number() {
  #
  string_trim_characters_before() {
    character_number_desired="$1"
    shift
    # $2*
    string="$*"
    #
    # Cut off all preceeding characters.
    i=1
    until [ $i -eq "$character_number_desired" ]; do
      string="${string#?}"
      i=$(( i + 1 ))
    done
    \echo  $string
  }
  #
  string_get_first_character() {
    string="$*"
    #
    __="$string"
    while [ -n "$__" ]; do
      rest="${__#?}"
      first_character="${__%"$rest"}"
      \echo  "$first_character"
      return
    done
  }
  #
  string=$( string_trim_characters_before  "$character_number_desired"  "$string" )
  character=$( string_get_first_character  "$string" )
  \echo  "$character"
}


\echo  $( string_get_character_number  "$character_number_desired"  "$string" )
