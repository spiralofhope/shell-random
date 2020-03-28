#!/usr/bin/env  sh



seq_replacement() {
  # usage:
  # seq_replacement LAST
  # seq_replacement FIRST LAST
  # seq_replacement FIRST INCREMENT LAST
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
#seq_replacement   3
#=>  1 2 3
#seq_replacement   2   5
#=>  2 3 4 5
#seq_replacement   3   1   5
#=>  3 4 5
#seq_replacement   5  -1   3
#=>  5 4 3
#seq_replacement   6   2  10
#=>  6 8 10
#seq_replacement  10  -2   6
#=>  10 8 6
