#!/usr/bin/env  sh
# Add commas to numbers



comma() {
  if [ -z "$*" ]; then
    # Incorrect usage.
    return  1
  elif [ -z "$2" ]; then
    \echo  "$1"  |\
      \sed  --expression=':a'  --expression='s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'
  else
    # Incorrect usage.
    return  1
  fi
}
:<<'USAGE'
Although at the commandline, this works:
  comma 1000
This is the required way to use it when scripting:
  comma '1000'
Or more complex:
  count=$( comma $( \ls -1 . | \wc  --lines ) )
USAGE
