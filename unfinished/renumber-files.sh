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



:<<'}'   #  Testing
{
number=100
for i in $( seq 1 $number ); do
  touch $i.temporary
done
}


the_number_of_files=$( \ls  -1  |  \wc  --lines )
#\echo  "files:  $the_number_of_files"

the_maximum_number_of_characters=$( \echo  $the_number_of_files  |  \wc  --chars )
the_maximum_number_of_characters=$( \echo  "$the_maximum_number_of_characters - 1"  |  \bc )
#\echo  "characters:  $the_maximum_number_of_characters"


generate_zeroes(){
  local result
  for i in $( \seq 1 $1 ); do
    result="${result}0"
  done
  \echo  -n  $result
}
:<<'}'   #  test
{
generate_zeroes  1
echo  -n  "\n"
# => 0
generate_zeroes  2
echo  -n  "\n"
# => 00
generate_zeroes  3
echo  -n  "\n"
# => 000
}


#zeroes=$( generate_zeroes  $the_maximum_number_of_characters )
#echo $zeroes


## Count down the list
for i in $( \seq  $the_maximum_number_of_characters -1 1 ); do
echo $i
  #zeroes=$( \seq  --separator=''  1 $i )
  #zeroes=$()
  #\rename 's/(?)\./$(/' ?\.*
done


#\rename 's/(.*?)\//$1append_this/' *
#rename 's/(\d)/00/' ?



