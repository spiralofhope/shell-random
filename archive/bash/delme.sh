# Delete the current directory and related files
# TODO: Proper pass/fail test cases?
delme() {
  until [ "sky" = "falling" ]; do
    if [ ! "$#" -eq 0 ]; then echo "This script does not accept parameters." ; break ; fi
    if [ "$PWD" = "/" ]; then echo "Are you insane, trying to delete root?" ; break ; fi

    MYDIR="$PWD"
    cd ../
    # If it's blank, don't even prompt!
    # TODO: Remember the state of shopt and restore it after this script.
    shopt -s dotglob
    ANSWER=`ls "$MYDIR"/* 2> /dev/null`
    ERROR=$?
    if [ "$ANSWER" = "" ] || [ $ERROR -ne 0 ]; then
      rmdir "$MYDIR"
      echo Auto-deleted...
    else
      echo -n "deltree $MYDIR? [yes/NO]:  "
      read ANSWER
      if [[ "$ANSWER" =~ '^(y)' ]]; then
        rm -rf "$MYDIR"
        echo Deleted...
      else
        echo Aborting...
        cd "$MYDIR"
        break
      fi
    fi

    # Check if the rmdir or rm worked completely.
    # No need to be verbose here, since any error would get echoed to the terminal anyways.
    if [ -d "$MYDIR" ]; then cd "$MYDIR" ; fi

    # .tar.gz and the like will extract into a similar name
    # If I decide to nuke the directory, then prompt to nuke the file too.

    # For each matching file, prompt to delete it.
    # I'm not sure offhand how to do this another way.
    shopt -s dotglob
    for i in "$MYDIR".* ; do
      # Don't let this loop iterate if there's no success.
      if [ "$i" = "$MYDIR"'.*' ]; then continue ; fi
      ANSWER=no
      echo -n "Also delete $i? [yes/NO]:  "
      read ANSWER
      if [[ "$ANSWER" =~ '^(y)' ]]; then
        rm -fv "$i"
      else
        echo Aborting...
      fi
    done

  break
done
}

test() {
  delme_temp=/tmp/delme.$PPID
  mkdir "$delme_temp"
  cd "$delme_temp"
  # The test "archive" to be deleted when its associated directory is killed
  # togglable to test similar archive deletion
#  echo :> delme_killme.tar.gz
#  echo :> delme_killme.tar
  mkdir   delme_killme
  cd      delme_killme
  # togglable to test empty directories
#  echo :> somefile
  delme
  cd /tmp
  # togglable
  rm -rf "$delme_temp"
#  ls "$delme_temp"
}
# clear
# test
