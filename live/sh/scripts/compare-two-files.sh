#!/usr/bin/env  sh

# Given two files, output one of:
#   1.  Lines found only in file one
#   2.  Lines found only in file two
#   3.  Lines found in both files



#DEBUG='true'



:<<'}'   #  For `autotest.sh`
{
  if [ $# -eq 0 ]; then
    # Pass example parameters to this very script:
    "$0"  '01.txt'        '02.txt'  'first'
    #"$0"  '01.txt'       '02.txt'  'second'
    #"$0"  '01.txt'       '02.txt'  'both'
    #"$0"  'missing.txt'  '02.txt'  'first'
    #"$0"  '01.txt'       '02.txt'  'invalid'
    #"$0"  '01.txt'

    return
  fi
}




if   [ "$#" -ne 3 ]; then return  1; fi
case "$3" in
  'first'|'second'|'both')
    :
  ;;
  *)
    # TODO - instructions
    return 1
  ;;
esac
file_one="$1"
file_two="$2"
desired="$3"
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




#:<<'}'   #  Iterate
_compare_two_files(){
  case "$desired" in
    'both')
      while  \read  -r  compare_one; do
        while  \read  -r  compare_two; do
          if [ "$compare_one" = "$compare_two" ]; then
            \echo  "$compare_one"
            break
          fi
        done < "$file_two"
      done < "$file_one"
    ;;
    'first')
      while  \read  -r  compare_one; do
        while  \read  -r  compare_two; do
          if [ "$compare_one" = "$compare_two" ]; then
            compare_one=''
            break
          fi
        done < "$file_two"
        if [ ! "$compare_one" = '' ]; then
          \echo  "$compare_one"
        fi
      done < "$file_one"
    ;;
    'second')
      #
      # only_second
      #
      while  \read  -r  compare_two; do
        while  \read  -r  compare_one; do
          if [ "$compare_two" = "$compare_one" ]; then
            compare_two=''
            break
          fi
        done < "$file_one"
        if [ ! "$compare_two" = '' ]; then
          \echo  "$compare_two"
        fi
      done < "$file_two"
    ;;
  esac
}



_compare_two_files  $@
