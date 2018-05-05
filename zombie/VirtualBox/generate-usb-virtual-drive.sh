#!/usr/bin/env  sh
# 2016-03-23 - and on Lubuntu 14.04.4 LTS



_file='./usb.vmdk'
_disk='/dev/sdc'
_user='user'
_group='user'



\rm  --force  "$_file"

\sudo \
\vboxmanage \
  internalcommands \
  createrawvmdk \
    -filename "$_file" \
    -rawdisk  "$_disk" \
` # `

\sudo  \chown  "$_user":"$_group"  "$_file"
