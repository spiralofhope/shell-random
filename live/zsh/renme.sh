# TODO - Keep this as a separate .sh and just have an alias refer to it.  Dumbass.


# Rename the current directory
# This seems to work under vanilla shell.

# TODO - Rework this to be a vanilla shell script
#   This would need more thorough testing.
#   vanilla shell doesn't properly leave me cd'd into the renamed directory.

renme() {
  until [ 'sky' = 'falling' ]; do
    if [ $# -gt 0 ] && [ "$1" = '' ]; then \echo  'Uses an optional string.  No quoting is required.' ; break ; fi
    if [ "$PWD" = '/' ]; then \echo  'Are you insane, trying to rename root?' ; break ; fi

    MYDIR="$PWD"

    # If I was passed some text, then don't even prompt!
    # No quoting required baby!
    if [ $# -gt 0 ]; then
      ANSWER=$@
    else
      \echo  'Rename $MYDIR to:'
      \echo  -n  '> '
      \read  ANSWER
      # ^c already works as expected.
      if [[ "$ANSWER" = '' ]]; then \echo  'Aborting...' ; break ; fi
    fi

    \cd  ../
    \mv  "$MYDIR"  "$ANSWER"

    # Check if the rename worked completely
    if [ -d "$ANSWER" ]; then
      # The rename worked, cd into it.
      \cd  "$ANSWER"
    else
      # The rename must have failed, return to the original directory.
      \cd  "$MYDIR"
    fi

  break
done
}
