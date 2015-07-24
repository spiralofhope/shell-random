#!/usr/bin/env  sh




_go() {
  # Given a directory
  if [ -f "$1" ]; then
    continue
  fi
  # If it has only one subdirectory
  if [ $(\ls "$1" | wc -l) -ne 1 ]; then
    continue
  fi
  target=./$1/
  source=./$1/$( ls  --directory  ./$1/ )
  # TODO? - If the one subdirectory is named the same as its parent
  #         I don't think I'll do this.
  #\echo  " * Processing $1"
  # Move that one subdirectory's contents into its parent ($1)
  # FIXME? - I don't know why I can't double-quote $source
  \mv  $source/*  "$target"
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
