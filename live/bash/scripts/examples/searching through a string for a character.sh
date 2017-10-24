#!/usr/bin/env  bash



#test=true


# ----------------------
# Counting from the left
# ----------------------
searchstring() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ $( \expr  length  "$1" ) -gt 1 ]; then
      \echo  'ERROR - Needs two parameters: a character, and a string'
      break
    fi
    character="$1"
    string="$2"
    # Iterate through the string.
    for i in $( \seq  0  $((${#string} - 1)) ); do
      # Checking that location in the string, see if the character matches.
      # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
      if [ "${string:$i:1}" = "$character" ]; then
        searchstring_success="$i"
      fi
    done
    if [ ! "$searchstring_success" = '' ]; then
      \echo  "$searchstring_success"
    else
      \echo  '-1'
    fi
    break
  done
}
searchstring_test() {
  \echo
  \echo  "given 'abcde', search for the position of 'b' from the left, starting with 0"
  searchstring  'b'  'abcde'
  # =>
  # 1
  \echo  "given 'abcde', search for the position of 'f' (not found) from the left, starting with 0"
  searchstring  'f'  'abcde'
  # =>
  # -1
}



# -----------------------
# Counting from the right
# -----------------------
# returns a character's position from the left of a string
searchstring_right_l() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ $( \expr  length  "$1" ) -gt 1 ]; then
      \echo  'ERROR - Needs two parameters: a character, and a string'
      break
    fi
    character="$1"
    string="$2"

    position=0
    length=${#string}
    until [ $length = -1 ]; do
      if [ "${string:$length:1}" = "$character" ]; then
        searchstring_success="$length"
      fi
      ((position++))
      ((length--))
    done
    if [ ! "$searchstring_success" = '' ]; then
      \echo  "$searchstring_success"
    else
      \echo '-1'
    fi
    break
  done
}
searchstring_right_l_test() {
  \echo
  \echo  "given 'abcde', search for the position of 'b' from the left, starting with 0"
  searchstring_right_l  'b'  'abcde'
  # =>
  # 1
}



# -----------------------
# Counting from the right
# -----------------------
# returns a character's position from the right of a string
searchstring_right_r() {
  unset searchstring_success
  until [ 'sky' = 'falling' ]; do
    # 2 parameters, no blanks, first parameter  must be one character.
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] || [ $( \expr  length  "$1" ) -gt 1 ]; then
      \echo  'ERROR - Needs two parameters: a character, and a string'
      break
    fi
    character="$1"
    string="$2"
    position=0
    length="${#string}"
    until [ "$length" = -1 ]; do
      if [ "${string:$length:1}" = "$character" ]; then
        searchstring_success="$position"
      fi
      ((position++))
      ((length--))
    done
    if [ ! "$searchstring_success" = '' ]; then
      \echo  "$searchstring_success"
    else
      \echo  '-1'
    fi
    break
  done
}
searchstring_right_r_test() {
  \echo
  \echo  "given 'abcde', search for the position of 'b' from the right"
  searchstring_right_r  'b'  'abcde'
  # =>
  # 4
}




# -----------------------------
if [ ! $test ]; then exit 0; fi


searchstring_test
searchstring_right_l_test
searchstring_right_r_test
