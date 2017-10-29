#!/usr/bin/env  sh
# Learn if a variable is a number or not
# Thanks to
#   https://stackoverflow.com/questions/806906



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


\echo -n "result"
\echo "\t\tedited"


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

test_isnumber(){
  __=$( isnumber $1 )
  echo $2
  echo $__
}

test_isnumber -2 'signed number'
