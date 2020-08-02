#!/usr/bin/env  sh

# Determine if a given character is a number (0-9)



if [ -z "$*" ]; then
  #"$0"  '1'   # =>  0
  #"$0"  'a'   # =>  1
  #"$0"  '10'  # =>  0
  #"$0"  'a1'  # =>  1
  #\echo  $?
  return
fi


string="$@"


is_character_a_number() {
  case $* in
    [0-9])  return  0  ;;
    *)      return  1  ;;
  esac
}


first_character=$( string-fetch-first-character.sh  "$string" )
is_character_a_number  "$first_character"
