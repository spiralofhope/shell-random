#!/usr/bin/env  sh

# Iterate through a script's parameters, so if it is called via
#   script.sh  one two three
# .. then it can process those three parameters separately.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  test   3  "two words"
  return
fi



#:<<'}'   #  Iteration in its simplest form
{
  while [ $# -ne 0 ]; do
    # shellcheck disable=1001
    \echo  "$1"
    shift
  done
}



#:<<'}'   #  More fancy
{
  i='1'
  # The number of arguments is  $#
  while [ $# -ne 0 ]; do
    # shellcheck disable=1001
    \echo  "$i - $1"
    i="$(( i + 1 ))"
    # Removes the leftmost argument.
    shift
  done
}
