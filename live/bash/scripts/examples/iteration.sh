#!/usr/bin/env  bash
# Iterating through a list or array of some sort.
# bash 4.3.30(1)-release (i586-pc-linux-gnu)
# TODO - a lot more examples need to be made.  I've used arrays elsewhere, and that can be used as inspiration.



:<<'}'  #  
{
  numa=0 ; numb=3
  until [ $numa -eq $numb ]; do
    ((numa++))
    echo iterating...
  done
}


:<<'}'  #  Increment 1 to 10.
{
  for i in {1..10}; do echo $i; done
}


:<<'}'  #  Increment 1 to 10, with no line breaks.
{
  for i in {1..10}; do printf $i; done
}



variable=(
  string
  "one quoted string"
  separated words
  1
)
# This is the same:
variable=( string "two words" 1 )


:<<'}'  #  Iterate by line, ignoring beginning spaces.
# This does not accept "one quoted strong" as one item.  zsh does it properly.
{
  for i in ${variable[@]}; do
    echo $i
  done
}



:<<'}'  #  Passing an array to a fuction.
{
  testing() {
    for element in ${@}; do
      \echo  "$element"
    done
  }
  \echo
  testing  string  'two words'  1
}
