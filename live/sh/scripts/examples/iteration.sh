#!/usr/bin/env  sh
# Examples of iterating through a list / array (dash-compatible)



#:<<'}'   #  Counting up from 1 to 3
{
  start='1'
  end='3'
  while [ "$start" -le "$end" ]; do
    \echo  "$start"
    start=$(( start + 1 ))
  done
}



#:<<'}'   #  Counting up from 1 to 10, in steps of two.
{
  start='1'
  add='2'
  end='10'
  while [ "$start" -le "$end" ]; do
    \echo  "$start"
    start=$(( start + add ))
  done
}



#:<<'}'   #  Counting down from 3 to 1
{
  start='3'
  subtract='1'
  while [ "$start" -ge "$end" ]; do
    \echo  "$start"
    start=$(( start - 1 ))
  done
}



#:<<'}'   #  Counting down from 10 to 1, in steps of two.
{
  start='10'
  subtract='2'
  end='1'
  while [ "$start" -ge "$end" ]; do
    \echo  "$start"
    start=$(( start - subtract ))
  done
}


#:<<'}'  #  Iterating through each character in a variable
# I don't think it's possible to do it without external programs, when restricted to the Bourne shell (sh, dash, etc)
{  # Using grep
  \echo  '----'
  variable="two words"
  \echo  "$variable"  |  \grep --only-matching .  |  while  \read  -r  character;  do
    \echo  "$character"
    # An example, with prepending text:
    #echo "_ $character"
  done 
  \echo  '----'
}



#<<'}'  #  Build an array
{
  # Build an array manually:
  array="
    one  two   three
    second
    third
  "
  #
  # Build an array from the output of a command:
  #array=$( find . -maxdepth 1 )
}


#:<<'}'  #  Iterate through the lines in a variable.
{
  for line in $array; do
    \echo  "$line"
  done
}


#:<<'}'  #  Split by spaces, ignore extra spaces, ignore empty lines.
{
  for line in $array; do
    \echo  "$line"
  done
}


#:<<'}'  #  Split by spaces, ignore extra spaces, ignore empty lines, add your own text.
{
  for line in $array; do
    \echo  "some text:  $line"
  done
}



#:<<'}'  #  Split by lines, ignore extra spaces, accept empty lines.
{
  \echo "$array"  |  while  \read  -r  line; do
    \echo  "$line"
  done
}


#:<<'}'  #  Split by lines, ignore extra spaces, accept empty lines, append text.
{
  \echo  "$array"  |  while  \read  -r  line; do
    \echo  "_ $line"
  done
}


#:<<'}'  #  Split by lines, ignore beginning spaces, accept empty lines, accept inner spaces.
{
  \echo  "$array" | while  \read  -r  line; do
    \echo  "$line"
  done
}


#:<<'}'  #  Another way to iterate
{  
  # This may not work for everyone
  # GNU bash, version 4.3.33(1)-release (i686-pc-cygwin)
  # FIXME - 2018-05-17 - Dash 0.5.7-4+b1  --  This does not work as-expected.
  OLDIFS=$IFS
  \unset  IFS
  # Note that the default is supposed to be something like " \t\n" but I can't manually set that:
  #IFS=$( printf  " \t\n" )
  for line in $array; do
    \echo  "_ $line"
  done
  IFS=$OLDIFS
}


#:<<'}'  #  Iteration through lines in a file, method one
{
  while  \read  -r  line; do
    \echo  "Text read from file: $line"
  done < 'filename.ext'
}



#:<<'}'  #  Iteration through lines in a file, method two
{
  while IFS='' \read  -r  line; do
    \echo  "Text read from file: $line"
  done < 'filename.ext'
}



#:<<'}'  #  Iteration through a command's output
{
  \find  .  -maxdepth 1  |  while  \read  -r  line; do
    \echo  "Output of 'find': $line"
  done
}
