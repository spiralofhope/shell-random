#!/usr/bin/env  zsh



searchstring() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  while :; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 2  ] ||
       [   "$1"   = '' ] ||
       [   "$2"   = '' ] ||
       [ ${#1} -gt 1 ]
    then
      \echo "Needs two parameters: a character, and a string"
      break
    fi
    character="$1"
    string="$2"
    # Iterate through the string.
    for i in $( \seq  0  $(( ${#string} - 1 )) ); do
      # Checking that location in the string, see if the character matches.
      # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
      # zshism
      # shellcheck disable=2039
      if [ "${string:$i:1}" = "$character" ]; then searchstring_success=$i ; fi
    done
    # echo isn't using any flags..
    # shellcheck disable=2039
    if [ ! "$searchstring_success" = '' ]; then \echo "$searchstring_success" ; else \echo "-1" ; fi
    break
  done
}

searchstring_right_l() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  while :; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq  2 ] ||
       [   "$1"   = '' ] ||
       [   "$2"   = '' ] ||
       [ ${#1} -gt 1 ]
    then
      \echo "Needs two parameters: a character, and a string"
      break
    fi
    character="$1"
    string="$2"

    position=0
    length=${#string}
    until [ "$length" = -1 ]; do
      # zshism
      # shellcheck disable=2039
      if [ "${string:$length:1}" = "$character" ]; then searchstring_success="$length" ; fi
      # zshism
      # shellcheck disable=2039
      ((position++))
      # zshism
      # shellcheck disable=2039
      ((length--))
    done
    # echo isn't using any flags..
    # shellcheck disable=2039
    if [ ! "$searchstring_success" = '' ]; then \echo "$searchstring_success" ; else \echo '-1' ; fi
    break
  done
}

searchstring_right_r() {
  unset searchstring_success
  while :; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq  2 ] ||
       [   "$1"   = '' ] ||
       [   "$2"   = '' ] ||
       [ ${#1} -gt 1 ]
    then
      \echo  "Needs two parameters: a character, and a string"
      break
    fi
    character="$1"
    string="$2"
    position=0
    length="${#string}"
    until [ "$length" = -1 ]; do
      # zshism
      # shellcheck disable=2039
      if [ "${string:$length:1}" = "$character" ]; then searchstring_success="$position" ; fi
      # zshism
      # shellcheck disable=2039
      ((position++))
      # zshism
      # shellcheck disable=2039
      ((length--))
    done
    if [ ! "$searchstring_success" = '' ]; then \echo  "$searchstring_success" ; else \echo s ; fi
    break
  done
}



position_from_right_to_left() {
  while :; do
    if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ]; then \echo "Needs two parameters: a string and a number"; break ; fi
    if ! \
      _="$( "$2" + 1 )"
    then
      \echo  "$2 is not a number."
      break
    fi
    string="$1"
    position="$2"
    length="${#string}"
    iteration=0
    until [ "$length" -eq "$position" ]; do
      # zshism
      # shellcheck disable=2039
      ((iteration++))
      # zshism
      # shellcheck disable=2039
      ((length--))
    done
    \echo  "$iteration"
    break
  done
}
