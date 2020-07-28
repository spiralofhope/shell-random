#!/usr/bin/env  sh



# shellcheck disable=1001
\sudo  \mount \
  -t iso9660 \
  -o ro,unhide \
  /dev/cdrom \
  /media/cdrom0/ \
  ` # `

