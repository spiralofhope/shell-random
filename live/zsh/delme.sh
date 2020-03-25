#!/usr/bin/env  zsh
# Delete the current directory and related files
# WARNING:  Use at your own risk!  You do back up your files regularly, right?



# FIXME FIXME
#               THERE IS A REALLY BAD BUG WHICH GOES UP TWO DIRECTORIES AND DELETES FROM THERE..
#               IT HAS HIT ME TWICE.. MUST BE BECAUSE OF THE DIRECTORY NAME... exact reproduction notes are found in projects.txt

# TODO - make this universal for bash/zsh (shopt/setopt) or just use `find` in a nice way..
# TODO: Proper pass/fail test cases?
delme() {
  while :; do
#     if [ ! "$#" -eq 0 ]; then \echo 'This script does not accept parameters.' ; break ; fi
    if [ "$PWD" = '/' ]; then \echo  'Are you insane, trying to delete root?' ; break ; fi

    MYDIR="$PWD"
    \cd  ../ || return
    # If it's blank, don't even prompt!
    # TODO: Remember the state of shopt and restore it after this script.
    # bash:
    # shopt -s dotglob
    # zsh:
    # \setopt  dotglob
    ANSWER=$( \ls  -A  "$MYDIR" 2> /dev/null ) 
    ERROR=$?
    if [ "$ANSWER" = '' ] || [ $ERROR -ne 0 ]; then
      \rmdir "$MYDIR"
      \echo  'Auto-deleted...'
    else
      \echo  -n  "deltree $MYDIR/? [yes/NO]:  "
      if [ "$1" = '-f' ]; then
        ANSWER='y'
      else
        \read  -r  ANSWER
      fi
      if [[ "$ANSWER" =~ ^(y) ]]; then
        \rm  --force  --recursive  --verbose  "$MYDIR"
        \echo  'Deleted...'
      else
        \echo  'Aborting...'
        \cd  -  ||  return
        break
      fi
    fi

    # Check if the rmdir or rm worked completely.
    # No need to be verbose here, since any error would get echoed to the terminal anyways.
    if [ -d "$MYDIR" ]; then \cd  "$MYDIR" || return ; fi

    # .tar.gz and the like will extract into a similar name
    # If I decide to nuke the directory, then prompt to nuke the file too.

    # For each matching file, prompt to delete it.
    # I'm not sure offhand how to do this another way.
    # TODO: Remember the state of shopt and restore it after this script.
    # bash:
    # shopt -s dotglob
    # zsh:
    #\setopt  dotglob
    for i in "$MYDIR".* ; do
      # Don't let this loop iterate if there's no success.
      if [ "$i" = "$MYDIR"'.*' ]; then continue ; fi
      ANSWER='no'
      \echo  -n  "Also delete $i? [yes/NO]:  "
      if [ "$1" = '-f' ]; then
        ANSWER='n'
      else
        \read  -r  ANSWER
      fi
      if [[ "$ANSWER" =~ ^(y) ]]; then
        \rm  --force  --verbose  "$i"
      else
        \echo  'Aborting...'
      fi
    done

  break
done
}

delme_test() {
  delme_temp=/tmp/delme.$$
  \mkdir  "$delme_temp" || return
  \cd  "$delme_temp" || return
  # The test "archive" to be deleted when its associated directory is killed
  # togglable to test similar archive deletion
#  \echo :> delme_killme.tar.gz
#  \echo :> delme_killme.tar
  \mkdir   delme_killme || return
  \cd      delme_killme || return
  # togglable to test empty directories
#  echo :> somefile
  \delme  ''
  \cd  /tmp || return
  # togglable
  \rm  --force  --recursive  "$delme_temp"
#  \ls  "$delme_temp"
}
# \clear
# test
