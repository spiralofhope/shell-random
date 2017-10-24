#!/usr/bin/env  bash



#test=true



# Reasoning

# Bash only works with whole numbers and does not return any information about a remainder from a decimal place when dividing with / and since % does not do what I want, I made this function:



divide() {
  # Just simple for now.  Elsewhere I have more complex code that's more thorough
  isnumber() {
    if expr $1 + 1 &> /dev/null ; then
      \echo  '0'
    else
      \echo  '1'
    fi
  }

  # Since "exit" also exits xterm, I do this to allow "break" to end this procedure.
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = '' ] || [ "$2" = '' ] ; then
    \echo  'ERROR - Needs two parameters'
    break
  fi
  if [ ! `isnumber $1` -eq 0 ] || [ ! `isnumber $2` -eq 0 ] ; then
    \echo  'ERROR - Needs two numbers'
    break
  fi

  left=$1
  right=$2
  answer_left=$(( $left / $right ))

  # TODO: Allow a third input to specify the number of places to give (the number of 0s)
  # TODO: Or, allow notation like divide 1 2.12345 and detect the number of places after the dot.
  #   With that, I'd have to convert the string into numbers and remove the decimal for bash to work with.  Too much math for me.  =)
  # The number of 0s is the number of places displayed after the decimal.
  left=$(( $left * 10000 ))
  answer_right=$(( $left / $right ))
  # clean up $answer_left from the beginning of $answer_right
  answer_right=${answer_right#*$answer_left}

  # Add a dot.  Must be combined into a variable otherwise the final echo won't work.
  \echo  "$answer_left"'.'"$answer_right"

break
done
}



# -----------------------------
if [ ! $test ]; then exit 0; fi


divide 688 304
# =>
# 2.2631

__=$( divide 688 304 )
\echo  $__
# =>
# 2.2631
