#!/usr/bin/env  sh



# Start this process by default?  With a cron job of some sort?

# Isn't this sort of thing being done by default?  If not, why?



# TODO - I could automatically detect all btrfs filesystems..
# mount | grep btrfs
# .. and then run this on all of them.



# Scrubbing involves read‐ing all data from all disks and verifying checksums.
# Errors are corrected along the way if possible.

# -B  =  do not background, and print scrub statistics when finished.
\sudo  \btrfs  scrub start   -B /dev/sdx1

# If you want to know what's going on..
# \sudo  \btrfs  scrub status     /dev/sdx1


