#!/usr/bin/env  bash



#test=true



replace_character() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 3 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ "$3" = '' ] || [ $( \expr length "$1" ) -gt 1 ]; then
      \echo  'ERROR - Needs three parameters: a character, a string and a position'
      break
    fi
    \expr  "$3" + 1 &> /dev/null ; result=$?
    if [ "$result" -ne 0 ]; then
      \echo  "ERROR - $3 is not a number."
      break
    fi
    character="$1"
    string="$2"
    position="$3"
    length="${#string}"
    i='0'
    unset newstring
    until [ "$i" -eq "$length" ]; do
      if [ "$i" -eq "$position" ]; then
        newstring="$newstring$character"
      else
        newstring="$newstring${string:$i:1}"
      fi
      ((i++))
    done
    \echo  "$newstring"

    break
  done
}



# -----------------------------
if [ ! $test ]; then exit 0; fi


\echo  "replace_character 'c' '12345' '2'"
replace_character 'c' '12345' '2'
# =>
# 12c45
