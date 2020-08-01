#!/usr/bin/env  sh

# Rename the current directory
# This seems to work under vanilla shell.



renme() {
  while :; do
    if [ $# -gt 0 ] && [ "$1" = '' ]; then \echo  'Uses an optional string.  No quoting is required.' ; break ; fi
    if [ "$PWD" = '/' ]; then \echo  'Are you insane, trying to rename root?' ; break ; fi

    MYDIR="$PWD"

    # If I was passed some text, then don't even prompt!
    # No quoting required baby!
    if [ $# -gt 0 ]; then
      # zshism
      # shellcheck disable=2124
      ANSWER=$@
    else
      # shellcheck disable=2016
      \echo  'Rename $MYDIR to:'
      \printf  '> '
      \read  -r  ANSWER
      # ^c already works as expected.
      if [ "$ANSWER" = '' ]; then \echo  'Aborting...' ; break ; fi
    fi

    \cd  ../ || exit
    \mv  "$MYDIR"  "$ANSWER"

    # Check if the rename worked completely
    if [ -d "$ANSWER" ]; then
      # The rename worked, cd into it.
      \cd  "$ANSWER" || exit
    else
      # The rename must have failed, return to the original directory.
      \cd  "$MYDIR" || exit
    fi
    break
  done
}
