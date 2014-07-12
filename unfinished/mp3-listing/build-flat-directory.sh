#!/usr/bin/env  sh



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
