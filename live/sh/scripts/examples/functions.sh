#!/usr/bin/env  sh
# Re-using code blocks.
# Variously called functions, procedures, methods, etc. in various programming languages.



# TODO - Various things can be done with parameters.
# TODO - $*  $@  shift  and quoting



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
