#!/usr/bin/env  sh

# Search/replace a single character within a string.
# Does not search/replace strings within a string.


# Note - Some characters, like whatever "�" is, are technically multiple characters and are not usable in this script.
# TODO - Try to expand this into a string_search and string_replace



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  ','  '_'  'Hello, world'
  # =>
  # Hello_ world
  return
fi


character_to_search_for="$1"
character_to_replace_with="$2"
shift
shift
# $3*
string="$*"


string_replace_character() {
  character_to_search_for="$1"
  character_to_replace_with="$2"
  shift
  shift
  # $3*
  string="$*"
  __="$string"
  while [ -n "$__" ]; do
    string_without_first_character="${__#?}"
    first_character="${__%"$string_without_first_character"}"
    if [ "$first_character" = "$character_to_search_for" ]; then
      first_character="$character_to_replace_with"
    fi
    output="$output$first_character"
    #\echo  "$first_character"
    __="$string_without_first_character"
  done
  \echo  "$output"
}


string_replace_character  \
  "$character_to_search_for"  \
  "$character_to_replace_with"  \
  "$string"
