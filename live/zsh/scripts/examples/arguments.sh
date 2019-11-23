#!/usr/bin/env  zsh
#
# Universal examples are found with sh/arguments.sh



if [ -z $1 ]; then
  "$0"  test   arguments  "two words"
  return
fi



#echo  ${#*[@]} "arguments passed to this script."

# Iterate through parameters
for parameter in ${*[@]}; do
  echo  "some text:" $parameter
done
