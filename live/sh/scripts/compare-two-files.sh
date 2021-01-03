#!/usr/bin/env  sh

# Given two files
# Compare each line
# Produce three files:
#   1.  Only in file one
#   2.  Only in file two
#   3.  In both files



#DEBUG='true'



#:<<'}'   #  For `autotest.sh`
{
  if [ $# -eq 0 ]; then
    # Pass example parameters to this very script:
    "$0"  '01.txt'  '02.txt'

    return
  fi
}



# FIXME/TODO
c_only_first="c_only_first.txt"
c_only_second="c_only_second.txt"
c_both="c_both.txt"



# TODO - instructions
if   [ "$#" -ne 2 ]; then return  1; fi


file_one="$1"
file_two="$2"
# Sanity check - exists, is a file, is not empty
if [ ! -s "$file_one" ]; then exit 1; fi
if [ ! -s "$file_two" ]; then exit 1; fi



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}


# INT is ^C
trap control_c INT
control_c()
{
  \echo  'control-c detected.'
  exit  0
}




#:<<'}'   #  Setup
_setup() {
  # Make files:
  :>"$c_only_first"
  :>"$c_only_second"
  :>"$c_both"
}


#:<<'}'   #  Iterate
_compare_two_files(){
  #
  # only_first
  #
  while  \read  -r  compare_one; do
    while  \read  -r  compare_two; do
      if [ "$compare_one" = "$compare_two" ]; then
        \echo  "$compare_one"  >>  "$c_both"
        compare_one=''
        break
      fi
    done < "$file_two"
    if [ ! "$compare_one" = '' ]; then
      \echo  "$compare_one"  >>  "$c_only_first"
    fi
  done < "$file_one"
  #
  # only_second
  #
  #
  # only_first
  #
  while  \read  -r  compare_two; do
    while  \read  -r  compare_one; do
      if [ "$compare_two" = "$compare_one" ]; then
        compare_two=''
        break
      fi
    done < "$file_one"
    if [ ! "$compare_two" = '' ]; then
      \echo  "$compare_two"  >>  "$c_only_second"
    fi
  done < "$file_two"



  ##
  ## both
  ##
  #while  \read  -r  compare_one; do
    #while  \read  -r  compare_two; do
      #if [ "$compare_one" = "$compare_two" ]; then
        #\echo  "$compare_one"  >>  "$c_both"
        #break
      #fi
    #done < "$file_two"
  #done < "$file_one"
}



#:<<'}'
_list() {
  clear
  less "$c_only_first"
  clear
  less "$c_only_second"
  clear
  less "$c_both"
}



#:<<'}'
_teardown() {
  \rm  --force  --verbose  "$c_only_first"
  \rm  --force  --verbose  "$c_only_second"
  \rm  --force  --verbose  "$c_both"
}



_teardown
_setup
_compare_two_files
_list
_teardown




:<<'}'
  #  While this works, using cat makes a huge variable (and uses cat)
  {
  is_string_in_list() {
    string="$1"
    list="$2"
    for line in $list; do
      if [ "$string" = "$line" ]; then
        return  0
      fi
    done
    return  1
  }

  #
  # only_first
  #
  list=$( \cat  "$file_two" )
  while  \read  -r  compare_one; do
    if  \
      is_string_in_list  "$compare_one"  "$list"
    then
      \echo  "$compare_one"  >>  "$c_both"
    else
      \echo  "$compare_one"  >>  "$c_only_first"
    fi
  done < "$file_one"
}
