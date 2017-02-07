#!/usr/bin/env  sh

# GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
# zsh 5.0.7 (i586-pc-linux-gnu)



# This doesn't work as expected
#for line in $variable; do
#  echo $line
#done


# This iterates through the contents of 'find'..
OLDIFS=$IFS
IFS=$'\n'
for N in $(\find . -maxdepth 1 -type d); do
  echo "$N"
  echo "---"
done
IFS=$OLDIFS

