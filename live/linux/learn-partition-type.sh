#!/usr/bin/env  sh
# Learning a partition's filesystem

\sfdisk  --part-type /dev/sda  1

:<<'}'
{
  * 7 = NTFS
  * 82 = Swap
  * 83 = Linux (ext2/ext3/etc)
}
