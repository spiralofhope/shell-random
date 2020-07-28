#!/usr/bin/env  sh

# Return a specific character range from a string.
# If the two number are the same, it outputs just the one character.

# TODO - If the range is "negative" then reverse the order of the output.



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  3  5  'example'
  # =>
  # amp
  return
fi


# TODO - ensure this is a number
character_range_desired_begin="$1"
shift
# TODO - ensure this is a number
character_range_desired_end="$1"
shift
# $3*
string="$*"
string_original="$*"



# Lifted from `string-fetch-character.sh`
string_fetch_character() {
  # TODO - ensure this is a number
  character_number_desired="$1"
  shift
  # $2*
  string="$*"
  #
  string_get_character_number() {
    #
    string_trim_characters_before() {
      character_number_desired="$1"
      shift
      # $2*
      string="$*"
      #
      # Cut off all preceeding characters.
      i=1
      until [ $i -eq "$character_number_desired" ]; do
        string="${string#?}"
        i=$(( i + 1 ))
      done
      \echo  "$string"
    }
    #
    string_get_first_character() {
      string="$*"
      #
      __="$string"
      while [ -n "$__" ]; do
        rest="${__#?}"
        first_character="${__%"$rest"}"
        \echo  "$first_character"
        return
      done
    }
    #
    string=$( string_trim_characters_before  "$character_number_desired"  "$string" )
    character=$( string_get_first_character  "$string" )
    \echo  "$character"
  }
  #
  printf  '%s'  "$( string_get_character_number  "$character_number_desired"  "$string" )"
}



seq_replacement_increment() {
  start="$character_range_desired_begin"
  end="$character_range_desired_end"
  while [ "$start" -le "$end" ]; do
    \echo  "$start"
    start=$(( start + 1 ))
  done
}



#:<<'}'   #  A drop-in replacement for the common uses `seq`.
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


#\echo  "$string"
#\echo  "=>"
for i in $( seq_replacement  "$character_range_desired_begin"  "$character_range_desired_end" ); do
  string_fetch_character  "$i"  "$string_original"
done
\echo  ''
