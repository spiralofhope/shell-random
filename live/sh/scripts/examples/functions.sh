#!/usr/bin/env  sh



# TODO - Various things can be done with parameters.
# TODO - $*  $@  shift  and quoting



#:<<'}'
{  #  Re-using code
  _fun() {
    \echo  'some text'
  }

  _fun
  _fun
}



#:<<'}'
{  #  Sending information to code
  _fun() {
    \echo  'some text'  $1
  }

  _fun  one
  _fun  two
}



#:<<'}'
{  #  Sending information to code
  _fun() {
    \echo  'some text'
    return
    \echo  'this is not displayed'
  }

  _fun
  _fun
}



