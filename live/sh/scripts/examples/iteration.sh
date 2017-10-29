#!/usr/bin/env  sh




#:<<'}'
{  #  Basics
  # GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
  # GNU bash, version 4.3.30(1)-release (i586-pc-linux-gnu)
  # zsh 5.0.7 (i586-pc-linux-gnu)
  for i in $( \seq 1 1 10 ); do
    echo $i
  done
  echo
  for i in $( \seq 10 -1 1 ); do
    echo $i
  done
  # Another way:
  #for i in {1..10}; do echo $i; done
  # With no line breaks:
  #for i in {1..10}; do printf $i; done
}



#:<<'}'
{  #  Walking through each line in a variable.

  # NOTE - Notice how this removes beginning spaces:
  variable="
  testing
  multiple
  lines
  "

  # Or from a command:
  #variable=$( \find . -maxdepth 1 )

  # $variable cannot be quoted as "$variable"
  for line in $variable; do
    echo "_ $line"
  done
}
{  #  Another method:
  variable="
  testing
  multiple
  lines
  "
  echo "$variable" |\
  while read line;
  do
    echo $line
  done
}



#:<<'}'
# This may not work for everyone:
{  #  Iterate through the listing made by 'find'
  # GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
  OLDIFS=$IFS
  IFS=$'\n'
  for line in $( find . -maxdepth 1 ); do
    \echo  "_ $line"
  done
  IFS=$OLDIFS
}



#  Iterating through each character in a variable
{  # Using grep
  variable="testing"
  echo "$variable" |\
  grep -o . |\
  while read character;  do
    echo "_ $character"
  done 
}
# I don't think it's possible to do it without external programs, when restricted to the Bourne shell (sh, dash, etc)
