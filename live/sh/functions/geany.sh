#!/usr/bin/env  sh
# geany overwrites symlinks when the target is on an NTFS filesystem



geany() {
  # I don't understand why \geany won't work.
  # FIXME - This prevents the use of commandline switches.
  /usr/bin/geany "$( \realpath  $* )"
}
