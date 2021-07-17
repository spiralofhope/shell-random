#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
#   (I like backslashes)
# Change directory into a directory-symbolic-link's real location, or a file's directory.
# Requires `realpath`
# Usage:  cd "`food`"



# I'd love to hijack 'cd' directly using cd(), but that doesn't work.
cdd() {
  # Only the first line, in case the user does something like
  #   cdd `findfile_raw filename`
  for line in "$@"; do
    __="$line"
    break
  done
  #
  __="$( \realpath  "$__" )"
  # Alternate:
  #__="$( \readlink  --canonicalize "$__" )"
  #
  # taken from  `replace-dirname.sh`
  _dirname() {
    dir=${1:-.}
    dir=${dir%%"${dir##*[!/]}"}
    [ "${dir##*/*}" ] && dir=.
    dir=${dir%/*}
    dir=${dir%%"${dir##*[!/]}"}
    printf '%s\n' "${dir:-/}"
  }
  #
  if   [ -L "$__" ] && [ -d "$__" ] ; then  \cd  "$__"                   ||  return  $?
  elif                 [ -f "$__" ] ; then  \cd  "$( _dirname  "$__" )"  ||  return  $?
  else                                      \cd  "$@"                    ||  return  $?
  fi
  unset  __
}



cddf() { cdd  "$( findfile_raw  "$@" )" ; }
cddd() { cdd  "$( finddir_raw   "$@" )" ; }
