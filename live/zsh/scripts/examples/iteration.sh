#!/usr/bin/env  zsh
# 
# zsh 5.0.7 (i586-pc-linux-gnu)



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
#variable=( string "two words" 1 )


:<<'}'  #  Iterate by line, ignoring beginning spaces.
{
  for i in ${variable[@]}; do
    echo $i
  done
}



#:<<'}'  #  Pass an array to a function, then iterate through it.
{
  example() {
    for element in ${@[@]}; do
      echo some text $element
    done
  }
  example  "my text" two 3
}
