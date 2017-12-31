#!/usr/bin/env  sh



# It turns out to have a lot of quirks and not being very useful compared to using [[find]] raw at the commandline.  I guess I'll have to look up how to use find every time I want to perform an action globally.  Hrmph.

# In 4DOS this command is just "GLOBAL", a one-liner.  =/


#A similar idea would be to make a "recurse" script to make an action work up on the a tree, from this point through all the parents.


global() {
  # Only work with parameters 2..-1
  allofit=
  # Whoa, $1 is picking up *.txt and expanding it!
  # and with this, $1 is totally ignored!  set -o noglob
  for i in $@; do
    if [ "$i" = "$1" ]; then continue ; fi
    allofit="$allofit $i"
  done
  # Not having quotes around this removes the starting space.
  echo $allofit
}

global_test() {
  TEMP=/tmp/$global.PPID
  cd /tmp
  mkdir $TEMP
  cd $TEMP
  # Make some temp files.
  for i in {1..10}; do
    echo :>$i.txt
  done
  # Issue here:  This is doing matching.  =/
  global *.txt echo hi
  rm -rf $TEMP
}

global_test
