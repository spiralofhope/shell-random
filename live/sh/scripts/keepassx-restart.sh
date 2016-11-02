#!/usr/bin/env  sh

# Sometimes keepassx refuses to show on the taskbar (lxpanel)

\killall  --quiet  keepassx

\keepassx \
  /mnt/1/windows-data/l/live/keepassx-passwords--linux-and-windows.kdb \
  -min  -lock &

\keepassx \
  /l/keepassx-passwords--linux-only.kdb \
  -min  -lock &
