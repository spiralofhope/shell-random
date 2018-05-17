#!/usr/bin/env  bash
# 
# bash 4.3.30(1)-release (i586-pc-linux-gnu)



:<<'}'
{
  numa=0 ; numb=3
  until [ $numa -eq $numb ]; do
    ((numa++))
    echo iterating...
  done
}


:<<'}'  # Increment 1 to 10.
{
  for i in {1..10}; do echo $i; done
}


:<<'}'  # Increment 1 to 10, with no line breaks.
{
  for i in {1..10}; do printf $i; done
}
