#!/usr/bin/env  bash



#test=true

:<<NOTES
Problem:

- You are given a position from the right.
- Give it as a position from the left, starting with 0.

This was implemented for 'multiplication with decimal places.sh' because I had to insert a "." back in and I only knew the position from the right.
NOTES



position_from_right_to_left() {
  until [ 'sky' = 'falling' ]; do
    if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ]; then
      \echo  'ERROR - Needs two parameters: a string and a number'
      break
    fi
    \expr  "$2" + 1 &> /dev/null
    if [ $? -ne 0 ]; then
      \echo  "ERROR - $2 is not a number."
      break
    fi
    string="$1"
    position="$2"
    length="${#string}"
    iteration=0
    until [ "$length" -eq "$position" ]; do
      ((iteration++))
      ((length--))
    done
    \echo  $iteration
    break
  done
}



# -----------------------------
if [ ! $test ]; then exit 0; fi



position_from_right_to_left  0987654321  2  
#position_from_right_to_left  abcd  b
