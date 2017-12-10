#!/usr/bin/env  sh



#target=/tmp
target=/mnt/mnt/

# `man btrfs`  for the details.

# I don't think -f (flush) is a good idea during operation..
\sudo  \find  $target  -type f  -print | \xargs  -0  \sudo  \btrfs  filesystem  defragment  -clzo  -v
\sync
