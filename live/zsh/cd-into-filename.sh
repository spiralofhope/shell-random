#!/usr/bin/env  zsh



# Be able to cd into the directory of a file, because autocomplete gives a filename.
# TODO



# FIXME - none of this would work with autocomplete, so fuck it.
# Note that none of this was checked in bash-windows
:<<'}'
cd() {
## One would think something like this would work for multiple parameters, but it doesn't.  Well fuck it, the user (me) can \cd foo bar if they want to.
#  if [ x$2 == x ]; then
#    # do nothing
#    \echo -n ''
#  else
#    \cd  $*
#    return  $!
#  fi
#
  __="$1"
  if [ -f $1 ]; then
    # delete the crap off of the trailing slash
    __=$( \dirname "$1" )
 fi
  # check that what remains is sane
  [ -d $__ ]
  if [ $! -ne 0 ]; then
    \echo  ERROR:  This is not a directory:
    \echo  $__
    return  1
  fi
  # I have no idea what -P means.  Screw you, past self.  Document more.
  # FIXME - is there a long form for -P ?  There is no  man cd
  \cd  -P  "$__"
}
