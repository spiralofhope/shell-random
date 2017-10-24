#!/usr/bin/env  bash



# String length:

string=abc
length=${#string} # => 3



# Regular expression matching:

string=abcdefg
if [[ "$string" =~ '(.*)cd(.*)' ]]
then
  echo matched
else
  echo not matched
fi

# Creates $BASH_REMATCH for what was matched.



# Reverse string extraction:

string=abcdefg
position=4
truncate=${string:$position} # => efgh
echo ${string%$truncate*} # => abcd



# Reverse string extraction, with a run:

string=abcdefg
position=4
run=2
truncate=${string:$position} # => efgh
truncate=${string%$truncate*} # => abcd
echo ${truncate:$run} # => cd



# Take a string, output everything after another string.

string=abcdefg
match=abc
if [[ $string =~ $match ]]; then : ; fi
echo ${string#*$BASH_REMATCH}

# I dunno... something like this?

string="0x01a00112 0 5745 localhost Mozilla Firefox"
echo ${string#*`hostname`}

# This seems to work differently if string is $@ .. or using $@ directly instead of an intermediate variable..

# (not sure how to do this in the middle of it..)



# String extraction, from position:

string=abcdefg
position=2
echo ${string:$position} # => cdefg



# String extraction, from position and with a run:

string=abcdefg
position=2
run=2
echo ${string:$position:$run} # => cd



# String extraction, from a match: 

num=123.456
echo ${num%.*} # => 123
echo ${num#*.} # => 456



# Break out of a parameter in .bashrc in xterm, without killing xterm

parameter() {
  until [ "sky" = "falling" ]; do
    if [ ! "foo" = "bar" ]; then echo this should be the only line! ; break ; fi
    echo this should not be seen
    break
  done 
}



# Procedures:

testing() {
 echo "it works!"
}
testing

# => it works!

testing() {
 echo "it works! $1"
}
testing "string"

# => it works! string



# Pass an array to a procedure:

testing() {
  for element in ${@[@]}; do
    echo $element
  done
}
testing string "two words" 1
