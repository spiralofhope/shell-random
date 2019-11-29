#!/usr/bin/env  sh
# Instead of opening the symlink, open the file's realpath.
# Workaround for Geany overwriting symlinks when the target is on an NTFS filesystem.



geany() {
  local  commandline=
  for i in "$@"; do
    if [ -f $i ]; then
      commandline="$commandline $( \realpath  "$i" )"
    else
      commandline="$commandline $i"
    fi
  done
  # I don't understand why \geany won't work.
  /usr/bin/geany  $commandline
}
