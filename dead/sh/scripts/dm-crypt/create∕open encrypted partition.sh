#!/usr/bin/env  sh



partition=sda3

dev=/dev/$partition
name=${partition}_crypt
anna-install cryptsetup-udeb partman-crypto-dm
depmod -a
# If you don't have an encrypted partition, you can make one with:
# cryptsetup -y luksFormat  $dev
cryptsetup -v luksOpen $dev $name
# If you want, you can mount and interact with the partition.
# However, to do that you need to proceed a little further in the install before coming back to this shell.
#mkdir /$name
#mount /dev/mapper/$name /$name
