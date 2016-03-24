#!/usr/bin/env  zsh



# 2016-03-24 - Tested and works under:
#   zsh 5.0.2 (x86_64-pc-linux-gnu)


# Problem:
#
# * Given a directory
#   **  with many subdirectories
#   **  where there are many files
# * Build one single directory
#   **  which has a flat list of links to those files
#   **  by 'flat', I mean that directory has no subdirectories
# * Allow the processing of specific filenames
#   **  using fancy filename wildcards would be nice


# TODO - If there are filename collisions, automatically rename them.
#        ln has numbered backups



#verbose=--verbose

if [ -z $2 ]; then
\echo  "
Turn a series of files/directories into one directory of symbolic links.

$0  <directory>  <targets>

<targets> may be any number of files or directories.

Examples:

$0  scripts  **/*.sh
"
  \exit  1
fi



target_directory=$1
shift
\mkdir  --parents  $target_directory
if [ $? -ne 0 ]; then
  \echo  'error'
  \exit  1
fi



_ln() {
  \ln  --backup  --relative  --symbolic  $verbose  $1  --target-directory=$2
}



for i in $@; do
  if [ -d $i ]; then
    \find  $i  -L  -type d  -exec  _ln  {}  $target_directory \;
  else
    _ln  $i  $target_directory
  fi
done
