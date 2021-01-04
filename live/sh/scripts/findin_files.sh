#!/usr/bin/env  sh
# shellcheck  disable=1001
#   (I like backslashes)



:<<'}'   #  Usage
{
 Can double-quote to quote a single-quote.
   "I don't know"
 Can backslash to escape.
   I don\'t know
}



findin_files() {
  maxdepth="$1"
  color="$2"
  shift; shift  #  $3*
  \find  \
    .  \
    -maxdepth "$maxdepth"  \
    -type f  \
    -print0  \
    -iname  \'"$*"\' |\
      \xargs  \
        --no-run-if-empty  \
        --null \
        \grep  \
          --colour="$color"  \
          --fixed-strings  \
          --ignore-case  \
          --regexp="$*"

  unset  _findhelper_type
  unset  _findhelper_color
  unset  maxdepth
}



findin_files  "$@"
