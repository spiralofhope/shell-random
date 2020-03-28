#!/usr/bin/env  sh
# Rename all the files in the current directory so they are numbered, and padded with zeroes.
# This is useful for dumb file managers and utilities which sort by the first character first, like:
#   1 10 2 3 4 5 6 7 8 9
# 
# See also:
#   https://blog.spiralofhope.com/?p=53711



# IDEA - Sort extensions differently?
# So one directory with n.ext1 and n.ext2 would generate a different 001.ext1 001.ext2
# ls  -X



#:<<'}'   #  Testing
{
  start='1'
  end='100'
  while [ "$start" -le "$end" ]; do
    # Create an empty file:
    :>"$start.temporary"
    start=$(( start + 1 ))
  done
}


count_items_in_directory() {
  # Usage: count_items_in_directory /path/to/dir/*
  #        count_items_in_directory /path/to/dir/*/
  [ -e "$1" ] \
    &&  \printf  '%s\n'  "$#"  \
    ||  \printf  '%s\n'  0
}
the_number_of_files=$( count_items_in_directory "$PWD"/* )
the_maximum_number_of_characters=${#the_number_of_files}
\echo  "files:       $the_number_of_files"
\echo  "characters:  $the_maximum_number_of_characters"


generate_zeroes(){
  start='1'
  end="$1"
  while [ "$start" -le "$end" ]; do
    #\printf  '%s\n' "$start"
    result="${result}0"
    start=$(( start + 1 ))
  done
  \printf  'requested %s, received:  %s'  "$1"  "$result"
}
:<<'}'   #  test
{
generate_zeroes  1
printf  '\n'
# => 0
generate_zeroes  2
printf  '\n'
# => 00
generate_zeroes  3
printf  '\n'
# => 000
}


#return
#zeroes=$( generate_zeroes  $the_maximum_number_of_characters )
#echo $zeroes


# Count down the list
start="$the_maximum_number_of_characters"
while [ "$start" -ge 1 ]; do
  #zeroes=$( \seq  --separator=''  1 $i )
  #zeroes=$()
  #\rename 's/(?)\./$(/' ?\.*
  \echo  "$start"
  start=$(( start - 1 ))
done



#\rename 's/(.*?)\//$1append_this/' *
#rename 's/(\d)/00/' ?

