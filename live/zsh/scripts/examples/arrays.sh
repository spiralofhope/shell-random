#!/usr/bin/env  sh


# zsh 5.0.7 (i586-pc-linux-gnu)
array=( string "two words" 1 )
for element in ${array[@]}; do
  echo $element
done
