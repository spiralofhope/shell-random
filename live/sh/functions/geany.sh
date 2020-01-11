#!/usr/bin/env  sh
# Instead of opening the symlink, open the file's realpath.
# Workaround for Geany overwriting symlinks when the target is on an NTFS filesystem.



geany() {
  local  commandline=
  # I don't understand why \geany won't work.
  #/usr/bin/geany  &
  for i in "$@"; do
    if [ -f $i ]; then
      /usr/bin/geany  "$( \realpath  "$i" )" &
    else
      /usr/bin/geany  "$i" &
    fi
  done
}
