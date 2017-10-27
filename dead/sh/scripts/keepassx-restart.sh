#!/usr/bin/env  sh
# This script has been obsoleted, due to my move away from `KeePassX` to `KeePassXC`.
# Sometimes keepassx refuses to show on the taskbar (lxpanel)



\killall  --quiet  keepassx

\keepassx \
  /mnt/1/data-windows/live/keepassx-passwords--windows.kdb \
  -min  -lock &

\keepassx \
  /mnt/1/data-windows/live/keepassx-passwords--linux-and-windows.kdb \
  -min  -lock &

\keepassx \
  /l/keepassx-passwords--linux-only.kdb \
  -min  -lock &
