#!/usr/bin/env  sh
# Replace `seq`

# Note:  For simpler functionality, there is example copy-paste code at the bottom of this script.


# TODO - Tidy this up
# TODO - Autotest functionality



#:<<'}'   #  A drop-in replacement for the common uses `seq`.
replace_seq() {
  # usage:
  # replace_seq LAST
  # replace_seq FIRST LAST
  # replace_seq FIRST INCREMENT LAST
  case "$#" in
    1)   #  Incrementing from 1 to $1
      start='1'
      end="$1"
      while [ "$start" -le "$end" ]; do
        \echo  "$start"
        start=$(( start + 1 ))
      done
    ;;
    2)   #  Incrementing from $1 to $2 in steps of 1
      if [ "$2" -lt "$1" ]; then  return  1; fi
      start="$1"
      end="$2"
      while [ "$start" -le "$end" ]; do
        \echo  "$start"
        start=$(( start + 1 ))
      done
    ;;
    3)
      if    [ "$2" -gt 0 ] && [ "$1" -lt "$3" ]; then
        #  Incrementing from $1 to $3 in steps of $2
        start="$1"
        change="$2"
        end="$3"
        while [ "$start" -le "$end" ]; do
          \echo  "$start"
          start=$(( start + change ))
        done
      elif  [ "$2" -lt 0 ] && [ "$1" -gt "$3" ]; then
        #  Decrementing from $3 to $1 in steps of $2
        start="$1"
        change="$2"
        end="$3"
        while [ "$start" -ge "$end" ]; do
          \echo  "$start"
          start=$(( start + change ))                                   #  It's "+" because $change is a negative number.
        done
      else
        return  1
      fi
    ;;
    *)  return  1  ;;
  esac
}
#for i in $( replace_seq 3       ); do \echo "ok $i"; done
#=>  ok 1
#=>  ok 2
#=>  ok 3

#for i in $( replace_seq 2  4    ); do \echo "ok $i"; done
#=>  ok 2
#=>  ok 3
#=>  ok 4

#for i in $( replace_seq 2  1  4 ); do \echo "ok $i"; done
#=>  ok 2
#=>  ok 3
#=>  ok 4

#for i in $( replace_seq 4 -1  2 ); do \echo "ok $i"; done
#=>  ok 4
#=>  ok 3
#=>  ok 2

#for i in $( replace_seq 2  2  6 ); do \echo "ok $i"; done
#=>  ok 2
#=>  ok 4
#=>  ok 6

#for i in $( replace_seq 6 -2  2 ); do \echo "ok $i"; done
#=>  ok 6
#=>  ok 4
#=>  ok 2

#for i in $( replace_seq 2 -2 -4 ); do \echo "ok $i"; done
#=>  ok 2
#=>  ok 0
#=>  ok -2
#=>  ok -4


replace_seq  "$@"







:<<'# example_copy-paste_code'
#:<<'}'   #  Simple:  Increment from 1 to $1 in steps of 1
replace_seq_increment() {
  start='1'
  end="$1"
  while [ "$start" -le "$end" ]; do
    \echo  "$start"
    start=$(( start + 1 ))
  done
}
#for i in $( replace_seq_increment 3 ); do \echo  "ok $i"; done
#=>  ok 1
#=>  ok 2
#=>  ok 3



#:<<'}'   #  Simple:  Decrement from $1 to 1 in steps of 1
replace_seq_decrement() {
  start="$1"
  end="1"
  while [ "$start" -ge "$end" ]; do
    \echo  "$start"
    start=$(( start - 1 ))
  done
}
#for i in $( replace_seq_decrement 3 ); do \echo  "ok $i"; done
#=>  ok 3
#=>  ok 2
#=>  ok 1
# example_copy-paste_code
