#!/usr/bin/env  sh
# shellcheck disable=1001
# Drop any caches in memory.
# This is helpful for having less working memory to dump to a hibernation file.
# For example, using VirtualBox's "save the machine state".


# 1 to free pagecache
# 2 to free dentries and inodes
# 3 to free pagecache, dentries and inodes
cache_types_to_drop=3


\sudo  \echo  ''

free_before="$( \free  --human  --si )"
\sudo  \sync

\sudo  \sh  -c  "/bin/echo  $cache_types_to_drop  >  /proc/sys/vm/drop_caches"

\sudo  /sbin/sysctl  --write  vm.drop_caches="$cache_types_to_drop"  >  /dev/null

free_after="$( \free  --human  --si )"

\sudo  \sync

\echo  "$free_before"  |  \head  --lines=2
\echo  "$free_after"   |  \head  --lines=2  |  \tail  --lines=1
\echo  ''
