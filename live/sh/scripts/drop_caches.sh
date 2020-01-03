#!/usr/bin/env  sh
# Drop any caches in memory.
# This is helpful for having less working memory to dump to a hibernation file.
# For example, using VirtualBox's "save the machine state".



\sudo  \sync

# 1 to free pagecache
# 2 to free dentries and inodes
# 3 to free pagecache, dentries and inodes
__=3

\sudo  \sh  -c "/bin/echo $__ > /proc/sys/vm/drop_caches"
\sudo  /sbin/sysctl  --write vm.drop_caches=$__

\sudo  \sync
