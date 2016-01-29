#!/usr/bin/env  sh



\sync
\sudo  \echo -n ''
# I have no idea why this line won't fucking work.  I have to manually sudo above.
\sudo  \echo  3  >!  /proc/sys/vm/drop_caches



# /sbin/sysctl -w vm.drop_caches=3
# 1 to free pagecache
# 2 to free dentries and inodes
# 3 to free pagecache, dentries and inodes

