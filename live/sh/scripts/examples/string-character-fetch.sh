#!/usr/bin/env  sh

# Return a specific character from a string.


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  3  'example'
  return
fi


# TODO - ensure this is a number
character_position_desired="$1"
shift
string="$*"



string_get_character_number() {
  #
  string_trim_characters_before() {
    character_position_desired="$1"
    shift
    string="$*"
    # Cut off all preceeding characters.
    i=1
    until [ $i -eq "$character_position_desired" ]; do
      string="${string#?}"
      i=$(( i + 1 ))
    done
    \echo  $string
  }
  #
  string_get_first_character() {
    string="$*"
    __="$string"
    while [ -n "$__" ]; do
      rest="${__#?}"
      first_character="${__%"$rest"}"
      \echo  "$first_character"
      return
    done
  }
  #
  string=$( string_trim_characters_before  "$character_position_desired"  "$string" )
  character=$( string_get_first_character  "$string" )
  \echo  "$character"
}


\echo  $( string_get_character_number  "$character_position_desired"  "$string" )
