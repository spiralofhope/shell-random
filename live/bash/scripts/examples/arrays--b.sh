#!/usr/bin/env  sh



# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
array=( string "two words" 1 )
for element in ${array[@]}; do
  echo $element
done
