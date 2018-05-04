#!/usr/bin/env  sh
# Learn if a variable is a number or not
# Thanks to
#   https://stackoverflow.com/questions/806906


#command | tee out.txt
#ST=$?

# =>

# Expecting 0
#echo "10 + 10" | bc; echo $?
# Expecting 1 (from `bc`), but getting 0 (from `echo`)
#echo "10 + a." | bc; echo $?

command_one() {
  # Expecting a return code of 0, because "bc 10 + 10" outputs "10"
  #\echo  '10 + 10'
  # Expecting a return code of 1, because "bc 10 + a." throws an error
  # However, this always returns "0"
  \echo  '10 + a.'
}
command_two() {
  \bc  > /dev/null 2> /dev/null
}


command_one | command_two
echo $?
# (always returns "0")
# -------------------------



command_one() {
  # Expecting a return code of 0, because "bc 10 + 10" outputs "10"
  #\echo  "10 + 10"
  # Expecting a return code of 1, because "bc 10 + a." throws an error
  # However, this always returns "0"
  \echo  '10 + a.'
}
command_two() {
  \bc  > /dev/null 2> /dev/null
}

{ # setup
  pipe_file='./pipe_file'
  \rm  --force        "$pipe_file"
  \mkfifo --mode=700  "$pipe_file"
}

# So instead of the following:
# command_one | command_two
#echo $?
# We do:
command_two < "$pipe_file" &
command_one > "$pipe_file"
\echo  $?

{ # teardown
  \rm  --force  "$pipe_file"
}


exit

check() {
  pipe_file='./pipe_file'
  \rm  --force  "$pipe_file"
  \mkfifo       "$pipe_file"


  bc > /dev/null < $pipe_file &
  echo "$*" >  "$pipe_file"
  __=$?
  \rm  --force  "$pipe_file"
  #echo $__
  #return $__
}

check  '10 + 10'
\echo  $?
check  '10 + a'
#echo  $?
#check  '1 + 10'
#echo  $?


exit 0

## Using expr
## This will detect integers only:
#isnumber() {
  #\expr 1 + $1  > /dev/null 2> /dev/null
  #__=$?
  #if [ $__ -eq 2 ]; then
    #\echo "no:  $1"
    #return  $__
  #else
    #\echo "yes:  $1"
    #return  $__
  #fi
#}

## Using bc
#isnumber() {
  #\echo  "10 + $1" | \bc   > /dev/null 2> /dev/null
  #__=$?
  #if [ $__ -eq 2 ]; then
    #\echo "no:  $1"
    #return  $__
  #else
    #\echo "yes:  $1"
    #return  $__
  #fi
#}


#first_command | second

#command | \tee out.txt

# Using bc
isnumber() {
  \rm  --force  pipe  out.txt




    \mkfifo pipe
    \tee out.txt < pipe &
    command > pipe
    \echo  $?



  __=$?
echo $__

return 0

  if [ $__ -eq 0 ]; then
    \echo "yes:  $1"
  else
    \echo "no:  $1"
  fi
  \rm  --force  pipe  out.txt
  return  $__
}



:<<'}'
isnumber() {
  \echo  "checking $@"
  # Iterating through each character in a variable
  # Using grep
  variable="$@"
  \echo  "$variable" |\
  # Oh fuck off, this is ignoring the period ..
  \grep  -o . |\
  while read character;  do
    \printf  ">   $character"
    case "$character" in
      [0-9])
        echo "   $character"
        break
      ;;
      *)
        echo " x $character"
        continue
      ;;
    esac
  done
}


# There are some fundamental limitations with the below:
:<<'}'
isnumber() {
  variable=$*

  case "$variable" in
    '')
      __="blank\t\tfalse"
    ;;
    [-+][0-9]*)
      __="signed number\ttrue"
    ;;
    [0-9])
      __="single digit\ttrue"
    ;;
    [0-9][0-9])
      __="double digit\ttrue"
    ;;
    [-+][0-9]*[.][0-9]*)
      __="signed float\ttrue"
    ;;
    [0-9]*[.][0-9]+)
      __="float\t\ttrue"
    ;;
    *)
      __="not a number\tfalse"
    ;;
    #[0-9]*[^^0-9])
    [0-9]*)
      __="multiple digit\ttrue"
    ;;
  esac
  \echo "$variable\t$__"
}


# Quoting is optional
isnumber  -2
isnumber  -1
isnumber  0
isnumber  1
isnumber  2
isnumber  10
isnumber  100
isnumber  -0
isnumber  +1
isnumber  -1.0
isnumber  0.0
isnumber  1.0
isnumber  +1.0
isnumber  1.0.1
isnumber  -1.0.1
isnumber  +1.0.1
isnumber  1.
isnumber  1-
isnumber  a
isnumber  a1
isnumber  a1.0
isnumber
isnumber  100
isnumber  1000
isnumber  12:34
isnumber  1.
isnumber  1.02abc
