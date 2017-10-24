#!/usr/bin/env  sh



# 2017-10-23 - Tested on Devuan-1.0.0-jessie-i386-DVD with:
#   dash 0.5.7-4
#debug=true



debug() {
  if [ $debug ]; then
    \echo  $*
  fi
}



_go() {
  if [ $debug ]; then
    \echo  " * Processing:  $1"
  fi

  {  # Skip if not a directory
    if [ ! -d "$1" ]; then
      debug  "   Skipping (not a directory)"
      continue
    fi
  }


  {  # Skip if more than one item.
    number_of_files_in_directory=$( \ls  --almost-all  -1 "$1"/ | \wc  --lines )
    debug  "   $number_of_files_in_directory items within."
    if [ $number_of_files_in_directory -ne 1 ]; then
      continue
    fi
  }


  {  # Skip is that one item is not a subdirectory.
    if [ ! -f "$( \ls  --almost-all  -1 "$1"/ )" ]; then
      debug  "   Skipping (not a subdirectory)"
      continue
    fi
  }


  target=./"$1"/
  source=./"$1"/$( \ls  --directory  ./"$1"/ )
  # Move that one subdirectory's contents into its parent ($1)
  \mv  "$source"/*  "$target"
  # Remove the now-empty directory
  \rmdir  "$source"
}


if [ -z "$1" ]; then
  for i in *; do
    _go "$i"
  done
else
  for i in "$@"; do
    _go "$i"
  done
fi
