#!/usr/bin/env  zsh



insert_character() {
  unset searchstring_success
  while :; do
  # 2 parameters, no blanks, first parameter  must be one character.
  # I should use -z and not = ''
  if [ ! "$#" -eq 3  ] ||
     [   "$1"   = '' ] ||
     [   "$2"   = '' ] ||
     [   "$3"   = '' ] ||
     [ $( \expr length $1 ) -gt 1 ];
  then
    \echo  'Needs three parameters: a character, a string and a position'
    break
  fi
  if ! \
    _"$( \expr "$3" + 1 )"
  then
    \echo "$3 is not a number."
    break
  fi
  character="$1"
  string="$2"
  position="$3"
  length=${#string}
  i=0
  unset newstring
  until [ "$i" -eq "$length" ]; do
    newstring="$newstring${string:$i:1}"
    ((i++))
    if [ "$i" -eq "$position" ]; then newstring="$newstring$character" ; fi
  done
  \echo  "$newstring"
  break
  done
}

replace_character() {
  unset searchstring_success
  while :; do
    # 2 parameters, no blanks, first parameter  must be one character.
    # I should use -z and not = ''
    if [ ! "$#" -eq 3 ] ||
       [   "$1"   = '' ] ||
       [   "$2"   = '' ] ||
       [   "$3"   = '' ] ||
       [ "$( \expr length "$1" )" -gt 1 ];
    then
      \echo  'Needs three parameters: a character, a string and a position'
      break
    fi
    if ! \
      _="$( \expr $3 + 1 )"
    then
      \echo "$3 is not a number."
      break
    fi
    character="$1"
    string="$2"
    position="$3"
    length=${#string}
    i=0
    unset newstring
    until [ "$i" -eq "$length" ]; do
      if [ "$i" -eq "$position" ]; then  newstring="$newstring$character"
      else                               newstring="$newstring${string:$i:1}"
      fi
      ((i++))
    done
    \echo  "$newstring"
    break
  done
}

