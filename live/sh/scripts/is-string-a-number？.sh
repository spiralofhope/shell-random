#!/usr/bin/env  sh

# Determine if a given string is made up wholly of numbers (0-9)



if [ $# -eq 0 ]; then
  #"$0"  '1'    # =>  0
  #"$0"  '123'  # =>  0
  #"$0"  'a'    # =>  1
  #"$0"  'abc'  # =>  1
  #"$0"  'a1'   # =>  1
  #"$0"  '1a'   # =>  1
  #"$0"  '2020-08-01 - string'  # =>  1
  #\echo  $?
  return  2
fi



string="$*"
#\echo  "$string"



character_range_desired_begin=1
character_range_desired_end=${#string}
for i in $( replace-seq.sh  "$character_range_desired_begin"  "$character_range_desired_end" ); do
  character="$( string-fetch-character.sh  "$i"  "$string" )"
  #is-character-a-number？.sh  "$character"
  #__=$?
  #printf '%d\t%s\t%s\n'  "$i"  "$character"  "$__"
  if ! \
    is-character-a-number？.sh  "$character"
  then
    return  1
  fi
done



return  0
