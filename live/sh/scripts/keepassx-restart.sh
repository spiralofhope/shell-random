#!/usr/bin/env  sh

# Sometimes keepassx refuses to show on the taskbar (lxpanel)

\killall  --quiet  keepassx

\keepassx \
  /mnt/1/data-windows/l/live/keepassx-passwords--windows.kdb \
  -min  -lock &

\keepassx \
  /mnt/1/data-windows/l/live/keepassx-passwords--linux-and-windows.kdb \
  -min  -lock &

\keepassx \
  /l/e/keepassx-passwords--linux-only.kdb \
  -min  -lock &
