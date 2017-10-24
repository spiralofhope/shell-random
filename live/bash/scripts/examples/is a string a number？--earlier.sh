#!/usr/bin/env  bash



# ------------
# Common stuff
# ------------

# printf inexplicably fails if given a string with a - as the first character.  Using " or ' and it seems to not correctly respond to \

test() {
  check() {
    isnumber "$1"
    if [ $? -eq 0 ] &>/dev/null ; then
      printf "yes"
    else
      printf "no"
    fi
    echo " - $1"
  }

  echo ""
  echo "Not numbers: "
  check "a"
  check "abcdefghijklmnopqrstuvwxyz"
  check "a."
  check "-a"
  check "+a"
  check "a1"
  check "a1.0"
  check "++1"
  check "--1"
  check "1--"
  check "1++"
  check "..1"
  check "1.."
  check "1..0"
  check "1.1.1"
  check "-"
  check "+"
  check "."
  check "--"
  check "++"
  check ".."

  echo ""
  echo "Numbers: "
  check "11"
  check "1"
  check "0"
  check "1."
  check ".1"
  check "-1"
  check "+1"
  check "+.1"
  check "-.1"
  check "1.1"
  check "-1.1"
  check "+1.1"
}


# regexp='^[-|+|0-9|.][.0-9]*$'



# using grep
isnumber() {
  if echo $1 | grep '\($regexp\)' &> /dev/null ; then
    return 0
  else
    return 1
  fi
}



# sed
# Set returns what it matched..

isnumber() {
  check=`echo $1 | sed "s/\($regexp\)//"`
  if [ -z ${check} ] ; then
    return 0
  else
    return 1
  fi
}




# bash regular expression
# This leverages the return code of an "expr" regular expression match.

isnumber() {
  if expr match "$1" "\($regexp\)" &> /dev/null ; then
    return 0
  else
    return 1
  fi
}



# Integers only (1, not 1.01) - leveraging bash typeset

isnumber() {
  typeset -i chkvar
  let "foo=$1" 2>/dev/null
}



# Integers only (1, not 1.01) - checking if math can be performed on it
# This leverages the return code of "expr".  So I try some math to see if it works or errors.

isnumber() {
  if expr $1 + 1 &> /dev/null ; then
    echo "yes"
  else
    echo "no"
  fi
}



:<<NOTES

isnumber() {
  expr $1 + 1 &> /dev/null ; result=$?
  if [ $result = 0 ]; then
    echo "yes"
  else
    echo "no"
  fi
}
NOTES