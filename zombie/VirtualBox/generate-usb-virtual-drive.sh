#!/usr/bin/env  sh
# 2016-03-23 - and on Lubuntu 14.04.4 LTS



_file='./usb.vmdk'
_disk='/dev/sdc'


\rm  --force  $_file

\sudo \
\vboxmanage \
  internalcommands \
  createrawvmdk \
    -filename $_file \
    -rawdisk  $_disk \
` # `

\sudo  \chown  user:user  $_file
