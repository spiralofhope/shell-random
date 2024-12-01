#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
  # (I like backslashes)

# mv sucks because it can't merge directories.
# NOTE - This script can't handle subdirectories.  There's probably a straightforward way to iterate through the tree but I'm not going to be bothered with that right now..



# Alternatives:
#
# tar:
#   https://blog.spiralofhope.com/?p=45093#merging-directories
#
# rsync:
#   https://blog.spiralofhope.com/?p=6999#merging-directories



mv_merge() {
  directory_source="$1"
  directory_target="$2"

  _basename() {
    # See  `replace-basename.sh`
    dir=${1%${1##*[!/]}}
    dir=${dir##*/}
    dir=${dir%"$2"}
    printf '%s\n' "${dir:-/}"
  }

  directory_initial="$PWD"
  _teardown()  {
    \cd  "$directory_initial/"  ||  return  $?
    for  signal  in  INT QUIT HUP TERM EXIT; do
      trap  -  "$signal"
    done
  }
  trap  _teardown  INT QUIT HUP TERM EXIT

  if   [ ! -d "$directory_target" ]  \
    || [ ! -d "$directory_source" ];
  then
    \echo  'The source and target must be directories.'
    return  1
  fi

  \find  "$directory_source"  -maxdepth 1  -name '*'  -type f  -print0  |\
    \xargs  -0  \
      \mv  --verbose  --no-clobber  --target-directory "$directory_target/"  ||  return  $?

  \rmdir  "$directory_source/"
  \cd  "$directory_target/"  ||  return  $?
}



:<<'}'  #  Untested
# https://www.linuxquestions.org/questions/linux-software-2/using-mv-to-move-the-contents-of-one-directory-into-another-444738/
# You run the code from within the directory which contains the subfolders you wish to move. If you are moving the subfolders up into the directory you are working from (say, '/home/user/photos/holidays' to '/home/user/photos'), you can replace 'DESTINATION DIRECTORY' with the variable $directory_current.
#
# This method avoids the problem of copying an entire directory's subfolders and potentially taking up too much disk space.
#
# The other thing is, you can change the asterisk in the 'find' command to search for specific files, such as *.jpg, *.pdf, whatever.
{
  for directory in $( find -name '*' -printf '%h\n' > TEMPFILE.txt; cat TEMPFILE.txt | sort -u ) ; do directory_current=$( pwd ); cd "$directory"; mv -t "DESTINATION DIRECTORY" *; cd "$directory_current"; done
}
