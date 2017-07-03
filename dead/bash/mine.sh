# TODO: implement 'global' with find

alias ls='ls --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Make and change into a directory:
mcd() { mkdir "$1" && cd "$1" ; }

# A proper dir command!
dir() { /bin/ls --color -gGh "$@"|cut -d" " -f4-100 ; }

# File/Directory-finding helpers.  Saves keystrokes.
# uses grep to colour.
findfile() { find -type f -name \*"$1"\*|grep --colour=always -i "$1" ; }
finddir()  { find -type d -name \*"$1"\*|grep --colour=always -i "$1" ; }
findin() { find ./ -type f -name '*' -print0 | xargs -r0 grep --colour=always -Fi "$1" ; }


# if a file exists, act on it.
# warning: Your command won't prompt!  (so rm will nuke files)
ifexists() {
  if [ -a "$2" ]; then
    "$1" "$2"
  fi
}

searchstring() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  # Iterate through the string.
  for i in $(seq 0 $((${#string} - 1))); do
    # Checking that location in the string, see if the character matches.
    # I should convert this into an 'until' so it makes sense to me, and it halts on the first success.
    if [ "${string:$i:1}" = "$character" ]; then searchstring_success=$i ; fi
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}

searchstring_right_l() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"

  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$length ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}

searchstring_right_r() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs two parameters: a character, and a string"; break ; fi
  character="$1"
  string="$2"
  position=0
  length=${#string}
  until [ $length = -1 ]; do
    if [ "${string:$length:1}" = "$character" ]; then searchstring_success=$position ; fi
    ((position++))
    ((length--))
  done
  if [ ! "$searchstring_success" = "" ]; then echo $searchstring_success ; else echo "-1" ; fi
  break
  done
}

divide() {
  # Just simple for now.  Elsewhere I have more complex code that's more thorough
  isnumber() {
    if expr $1 + 1 &> /dev/null ; then
      echo "0"
    else
      echo "1"
    fi
  }

  # Since "exit" also exits xterm, I do this to allow "break" to end this procedure.
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] ; then echo "Needs two parameters"; break ; fi
  if [ ! `isnumber $1` -eq 0 ] || [ ! `isnumber $2` -eq 0 ] ; then echo "Needs two numbers"; break; fi

  left=$1
  right=$2
  answer_left=$(( $left / $right ))

  # TODO: Allow a third input to specify the number of places to give (the number of 0s)
  # TODO: Or, allow notation like divide 1 2.12345 and detect the number of places after the dot.
  #   With that, I'd have to convert the string into numbers and remove the decimal for bash to work with.  Too much math for me.  =)
  # The number of 0s is the number of places displayed after the decimal.
  left=$(( $left * 100 ))
  answer_right=$(( $left / $right ))
  # clean up $answer_left from the beginning of $answer_right
  answer_right=${answer_right#*$answer_left}

  # Add a dot.  Must be combined into a variable otherwise the final echo won't work.
  echo $answer_left"."$answer_right

break
done
}

position_from_right_to_left() {
  until [ "sky" = "falling" ]; do
  if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ]; then echo "Needs two parameters: a string and a number"; break ; fi
  expr $2 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then echo $2 is not a number. ; break ; fi
  string=$1
  position=$2
  length=${#string}
  iteration=0
  until [ $length -eq $position ]; do
    ((iteration++))
    ((length--))
  done
  echo $iteration
  break
  done
}

insert_character() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 3 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs three parameters: a character, a string and a position"; break ; fi
  expr $3 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then echo $3 is not a number. ; break ; fi
  character="$1"
  string="$2"
  position="$3"
  length=${#string}
  i=0
  unset newstring
  until [ $i -eq $length ]; do
    newstring=$newstring${string:$i:1}
    ((i++))
    if [ $i -eq $position ]; then newstring=$newstring$character ; fi
  done
  echo $newstring

  break
  done
}

replace_character() {
  unset searchstring_success
  until [ "sky" = "falling" ]; do
  # 2 parameters, no blanks, first parameter  must be one character.
  if [ ! "$#" -eq 3 ] || [ "$1" = "" ] || [ "$2" = "" ] || [ "$3" = "" ] || [ `expr length $1` -gt 1 ]; then echo "Needs three parameters: a character, a string and a position"; break ; fi
  expr $3 + 1 &> /dev/null ; result=$?
  if [ $result -ne 0 ]; then echo $3 is not a number. ; break ; fi
  character="$1"
  string="$2"
  position="$3"
  length=${#string}
  i=0
  unset newstring
  until [ $i -eq $length ]; do
    if [ $i -eq $position ]; then
      newstring=$newstring$character
    else
      newstring=$newstring${string:$i:1}
    fi
    ((i++))
  done
  echo $newstring

  break
  done
}


multiply() {
  until [ "sky" = "falling" ]; do
    if [ ! "$#" -eq 2 ] || [ "$1" = "" ] || [ "$2" = "" ] ; then echo "Needs two parameters"; break ; fi
    if [ ! `isnumber $1` -eq 0 ] || [ ! `isnumber $2` -eq 0 ] ; then echo "Needs two numbers"; break; fi
    a=$1
    b=$2

    # remove the . from either.
    a_nodot=${a//./""}
    b_nodot=${b//./""}

    # Multiply the decimal-less numbers together:
    sum=$(( $a_nodot * $b_nodot ))

    # Learn the position of "." in each.
    a_dotloc=`searchstring_right_r "." $a`
    b_dotloc=`searchstring_right_r "." $b`

    # Add one to it, to get its position in human terms.
    # If there was no dot (-1) then make it 0.
    if [ $a_dotloc -gt "-1" ]; then ((a_dotloc--)) ; else a_dotloc=0 ; fi
    if [ $b_dotloc -gt "-1" ]; then ((b_dotloc--)) ; else b_dotloc=0 ; fi

    # add the two positions of "." together
    dotloc=$(( $a_dotloc + $b_dotloc ))

    # insert "." into $sum
    # But first I must learn the proper insertion location.  Convert from from-right to the standard from-left.
    dotloc=`position_from_right_to_left $sum $dotloc`

    # insert a "." into $sum, but not at the end
    if [ $dotloc -ne ${#sum} ]; then sum=`insert_character "." "$sum" $dotloc` ; fi

    echo $sum
  break
  done
}
