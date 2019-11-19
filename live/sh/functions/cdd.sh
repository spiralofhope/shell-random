#!/usr/bin/env  sh
# Change directory into a directory-symbolic-link's real location, or a file's directory.



# I'd love to hijack 'cd' directly using cd(), but that doesn't work.
cdd() {
  local  target="$( \realpath "$*" )"
  if   [ -L "$*" ] && [ -d "$target" ] ; then  \cd  "$target"
  elif                [ -f "$target" ] ; then  \cd  "$( \dirname  "$target" )"
  else                                         \cd  "$*"
  fi
}
