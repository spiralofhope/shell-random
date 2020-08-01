#!/usr/bin/env  sh

# Rename the current directory


renme() {
  if  [ $# -eq 0 ]  ||\
      [ "$PWD" = '/' ]  ||\
      [ "$*" = "$PWD" ] ;
  then
    return  1
  fi
  #
  directory_desired="$*"
  directory_previous="$PWD"
  #\echo  "$directory_desired"
  #\echo  "$directory_previous"
  #
  \cd  ../  ||  return  $?
  #echo  "$*"
  \mv  "$directory_previous"  "$directory_desired"  ||  return  $?
  # If run as a function, then this will work:
  #   However, a script cannot make it's summoning shell  `cd`  into the new directory.
  \cd  "$directory_desired"  ||  \cd  "$directory_previous"  ||  return  $?
}



# Make sure my  `sourceallthat`  from  dash's  `.profile`  does not run this function:
if [ $# -eq 0 ] || [ "$1" = "$PWD/" ]; then return 1; fi

renme  "$*"
\echo  "$*"
