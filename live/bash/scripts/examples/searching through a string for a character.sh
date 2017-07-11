# searchstring "." "some.thing"

# ----------------------
# Counting from the left
# ----------------------
:<<'NOTE'

Returns the position of the item, or -1 if it's not found.

leftmost = 0

So the positions of abcde become:
 abcde
 =
 01234
NOTE


searchstring() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  # Iterate through the string.
  for i in $(seq 0 $((${#string} - 1))); do
    # Checking that location in the string, see if the character matches.
    # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
    if [ "${string:$i:1}" = "$character" ]; then searchstring_success=$i ; fi
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}


# -----------------------
# Counting from the right
# -----------------------
# giving position from the left

:<<NOTE
leftmost = 0

So the positions of abcde become:
 abcde
 =
 01234
NOTE


searchstring_right_l() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"

  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$length ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}



# -----------------------
# Counting from the right
# -----------------------
# giving position from the right

:<<NOTE
rightmost = 1

So the positions of abcde become:
 abcde
 =
 54321
NOTE


searchstring_right_r() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$position ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}
