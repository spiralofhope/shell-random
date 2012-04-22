renme() {
  until [ "sky" = "falling" ]; do
    if [ $# -gt 0 ] && [ "$1" = "" ]; then echo "Uses an optional string.  No quoting is required." ; break ; fi
    if [ "$PWD" = "/" ]; then echo "Are you insane, trying to rename root?" ; break ; fi

    MYDIR="$PWD"

    # If I was passed some text, then don't even prompt!
    # No quoting required baby!
    if [ $# -gt 0 ]; then
      ANSWER=$@
    else
      # TODO: Remember the state of shopt and restore it after this script.
      echo "Rename $MYDIR to:"
      echo -n "> "
      read ANSWER
      # ^c already works as expected.
      if [[ "$ANSWER" = "" ]]; then echo Aborting... ; break ; fi
    fi

    cd ../
    mv "$MYDIR" "$ANSWER"

    # Check if the rename worked completely
    if [ -d "$ANSWER" ]; then
      cd "$ANSWER"
    elif [ ! -d "$ANSWER" ]; then
      cd "$MYDIR"
    else
      echo The sky is falling!
    fi

  break
done
}