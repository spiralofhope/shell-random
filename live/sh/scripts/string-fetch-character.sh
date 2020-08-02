#!/usr/bin/env  sh

# Return a specific character from a string.


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  2  'example'   # =>  x
  #"$0"  3  'example'   # =>  a
  return
fi


# TODO - ensure this is a number
character_number_desired="$1"
shift
# $2*
string="$*"
string_original="$*"



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
    printf  '%s'  "$string"
  }
  #
  string=$( string_trim_characters_before  "$character_number_desired"  "$string" )
  character=$( string-fetch-first-character.sh  "$string" )
  printf  '%s'  "$character"
}


string_get_character_number  "$character_number_desired"  "$string_original"
\echo  ''
