#!/usr/bin/env  sh
# Make and change into a directory:



mcd() {
  directory="$@"
  if   [ -z "$1" ]; then
    directory="$( \date  +%Y-%m-%d )"
  elif [ -f "$*" ]; then   #  File
    directory="$( \dirname  "$@" )"
  fi
  # Silent errors:
  \mkdir  --parents  "$directory"
  \cd                "$directory"
}
