#!/usr/bin/env  bash



#test=true



insert_character() {
  unset searchstring_success
  while :; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 3  ] ||\
       [   "$1"   = '' ] ||\
       [   "$2"   = '' ] ||\
       [   "$3"   = '' ] ||\
       [ "$( \echo  "$1" | \wc -c )" -gt 1 ];\
    then
      \echo  'ERROR - Needs three parameters: a character, a string and a position'
      break
    fi
    if  ! \
      _="$(( "$3" + 1 ))"
    then
      \echo  "$3 is not a number."
      break
    fi
    character="$1"
    string="$2"
    position="$3"
    length="${#string}"
    i='0'
    unset newstring
    until [ "$i" -eq "$length" ]; do
      newstring="$newstring${string:$i:1}"
      ((i++))
      if [ "$i" -eq "$position" ]; then
      newstring="$newstring$character"
    fi
    done
    \echo  "$newstring"
    break
  done
}



# -----------------------------
if [ ! "$test" ]; then exit 0; fi


\echo  "insert_character 'c' '12345' '2'"
insert_character 'c' '12345' '2'
# =>
# 12c345
