#!/usr/bin/env  sh

# Return a specific character range from a string.
# If the two number are the same, it outputs just the one character.

# TODO - If the range is "negative" then reverse the order of the output.


#DEBUG='true'


if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  3  5  'example'
  # =>
  # amp
  #
  "$0"  2  3  'example'
  # =>
  # xa
  return
fi


DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}


# TODO - ensure this is a number
character_range_desired_begin="$1"
shift
# TODO - ensure this is a number
character_range_desired_end="$1"
shift
# $3*
string="$*"
string_original="$*"



# Lifted from `string-fetch-character.sh`
string_fetch_character() {
  # TODO - ensure this is a number
  character_number_desired="$1"
  shift
  # $2*
  string="$*"
  #
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
      \echo  "$string"
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
  #
  printf  '%s'  "$( string_get_character_number  "$character_number_desired"  "$string" )"
}


_debug  ''
_debug  "$string"
_debug  "=>"
for i in $( replace-seq.sh  "$character_range_desired_begin"  "$character_range_desired_end" ); do
  string_fetch_character  "$i"  "$string_original"
done
\echo  ''
