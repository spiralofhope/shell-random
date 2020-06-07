#!/usr/bin/env  sh
# Change directory into a directory-symbolic-link's real location, or a file's directory.



# I'd love to hijack 'cd' directly using cd(), but that doesn't work.
cdd() {
  _target="$( \realpath "$*" )"
  if   [ -L "$*" ] && [ -d "$_target" ] ; then  \cd  "$_target"                   ||  return  $?
  elif                [ -f "$_target" ] ; then  \cd  "$( \dirname  "$_target" )"  ||  return  $?
  else                                          \cd  "$*"                         ||  return  $?
  fi
  unset  _target
}
