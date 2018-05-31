
searchstring() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  # Iterate through the string.
  for i in $( \seq  0  $( ( ${#string} - 1 ) ) ); do
    # Checking that location in the string, see if the character matches.
    # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
    if [ "${string:$i:1}" = "$character" ]; then searchstring_success=$i ; fi
  done
  if [ ! "$searchstring_success" = "" ]; then \echo $searchstring_success ; else \echo "-1" ; fi
  break
  done
}

searchstring_right_l() {
  unset searchstring_success
  # TODO - I really need to stop doing this.
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ $( \expr length $1 ) -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"

  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$length ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then \echo $searchstring_success ; else \echo "-1" ; fi
  break
  done
}

searchstring_right_r() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ $( \expr length $1 ) -gt 1 ]; then \echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$position ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then \echo  $searchstring_success ; else \echo "-1" ; fi
  break
  done
}



position_from_right_to_left() {
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ]; then \echo "Needs two parameters: a string and a number"; break ; fi
  expr $2 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then \echo $2 is not a number. ; break ; fi
  string=$1
  position=$2
  length=${#string}
  iteration=0
  until [ $length -eq $position ]; do
    ((iteration++))
    ((length--))
  done
  \echo  $iteration
  break
  done
}
