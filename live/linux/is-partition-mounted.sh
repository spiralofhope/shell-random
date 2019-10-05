#!/usr/bin/env  sh
# Learn of a particular partition or mount point is in use.

# How do I learn if a partition is mounted?  `/proc/mounts`?  nope!  That mysteriously doesn't show your present root filesystem.
# Since fsck is retarded, I had to pipe other programs and wrap all that shit around fsck to build the fucking feature for it.


source='/dev/sda1'
\mount | \cut  -d' '  -f1 | \grep  "^$source\$"

target='/'
\mount | \cut  -d' '  -f3 | \grep  "^$target\$"




# Old notes, not a good way..
#__='/dev/sda1'
#\df | \cut -d' '  -f1 | \grep  "$__"
