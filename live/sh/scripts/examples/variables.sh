#!/usr/bin/env  sh



:<<'}'   #  Simple
{
  variable=example text one
  \echo  "$variable"
  # =>
  # example text one
  
}


:<<'}'   #  Set if it isn't already set
{
  unset  variable
  : "${variable:=example text two}"
  \echo  "$variable"
  # =>
  # example text two
}

:<<'}'   #  Set if it isn't already set
{
  variable='example text three'
  : "${variable:=replacement text}"
  \echo  "$variable"
  # =>
  # example text three

  # So you can do things like this (which will do nothing if $PATH is already set.)
  #: "${PATH:=$PATH:example text two}"
  #\echo  "$PATH"
}


#:<<'}'   #  If the variable is set, act on it
{
  : "${__:=$PATH}"
  # Appending to the path:
  echo "testing;$__"
}

