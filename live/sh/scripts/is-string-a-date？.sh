#!/usr/bin/env  sh

# Determine if a string is in the yyyy-mm-dd date format.



if [ -z "$*" ]; then
  #"$0"  '2020-08-01'      # =>  0
  #"$0"  '2020-0a-01'      # =>  1
  #"$0"  '2020-08-01 no'   # =>  1
  #"$0"  'text'            # =>  1
  #"$0"  '2020'            # =>  1
  #\echo  $?
  return
fi


string="$*"


is_string_a_date() {
  string="$*"
  #
  if [ ${#string} -ne 10 ]; then return 1; fi
  #
  for i in \
    $( string-fetch-character-range.sh  1   4  "$string" )  \
    $( string-fetch-character-range.sh  6   7  "$string" )  \
    $( string-fetch-character-range.sh  9  10  "$string" )  \
  ; do
    #\echo  "$i"
    if ! \
      is-string-a-number？.sh  "$i"
    then
      return  1
      break
    fi
  done
  for i in  \
    $( string-fetch-character.sh        5      "$string" )  \
    $( string-fetch-character.sh        8      "$string" )  \
  ; do
    if [ ! "$i" = "-" ]; then
      return  1
      break
    fi
  done
  return  0
}


is_string_a_date  "$string"
