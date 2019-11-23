#!/usr/bin/env  sh



if [ -z $1 ]; then
  "$0"  test   arguments  "two words"
  return
fi



echo $1
echo $2
echo $3
echo $4
echo --
echo $1 $2
