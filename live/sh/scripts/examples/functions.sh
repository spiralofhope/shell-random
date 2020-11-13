#!/usr/bin/env  sh
# Re-using code blocks.
# Variously called functions, procedures, methods, etc. in various programming languages.



# TODO - Various things can be done with parameters.
# TODO - $*  $@  shift  and quoting
# $@ has entries called "positional parameters" (and also "special parameters").
#   https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_05_02



#:<<'}'   #  Re-using code
{
  _fun() {
    \echo  'some text'
  }
  #
  _fun
  _fun
}



#:<<'}'   #  Sending information to code
{
  _fun() {
    \echo  'some text'  "$1"
  }
  #
  _fun  one
  _fun  two
}



#:<<'}'   #  Sending information to code
{
  _fun() {
    \echo  'some text'
    return
    \echo  'this is not displayed'
  }
  #
  _fun
  _fun
}



#:<<'}'   #  Returning information from code into a variable
{
  _fun() {
    \echo  'some text'
  }
  #
  __="$( _fun )"
  echo  "My variable's content is:  $__"
}



#:<<'}'   #  Returning information from code into a variable, and also using echo freely within it
{
  _fun() {
    \echo  'example text'  >&2
    \echo  'some text'
  }
  #
  __="$( _fun )"
  echo  "My variable's content is:  $__"
}
