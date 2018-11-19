#!/usr/bin/env  sh


:<<'from_sh'
findfile() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  file      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  file  ./  $*
  fi
}


finddir() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  directory      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  directory  ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findinall() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  999            $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  999        ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findhere() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  1              $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  1          ./  $*
  fi
}
from_sh



############
# From zsh #
############
# Roughly copied here.
# TODO - audit

# TODO? - update this using the style of findreplace
# File/Directory-finding helpers.  Saves keystrokes.
# uses grep to colour.
findfile() {
  # TODO: parameter-sanity
  \find  -type f  -iname  \*"$1"\* |\
  \sed  's/^/"/'|\
  \sed  's/$/"/' |\
  \grep  --colour=always  --ignore-case  "$1"
}
finddir() {
  # TODO: parameter-sanity
  \find  -type d  -iname  \*"$1"\* |\
  \sed  's/^/"/' |\
  \sed  's/$/"/' |\
  \grep  --colour=always  --ignore-case  "$1"
}
findin() {
  maxdepth=$1
  shift
  __=$1
  shift
  if [ -z $1 ]; then
    \echo "Usage:

$0  <directory>  <string>


Multiple unquoted words are valid
  $0 . this is an example

If you do anything fancy, quote!
  $0 . 'asterisk * example'
"
  else
    \find  $__  -maxdepth $maxdepth  -type f  -print0  -iname  \'"$*"\' |\
    \xargs  --no-run-if-empty  --null \
      \grep  --colour=always  --fixed-strings  --ignore-case  --regexp="$*"
  fi
}
# TODO: parameter-sanity?
findinall() { findin 999 ./ "$*" ; }
findhere()  { findin 1   ./ "$*" ; }

findreplace() {
  if [ -z $3 ]; then
    \echo  "Usage:  $0 search replace [file|wildcard]."
    \return  1
  fi
  local  search=$1
  local  replace=$2
  shift
  shift
  \sed  --in-place  "s/$search/$replace/g"  $*
}
