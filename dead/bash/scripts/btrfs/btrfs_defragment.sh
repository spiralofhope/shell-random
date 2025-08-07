#!/bin/env  sh



# Run this in the directory, and it will recursively defragment files..
\sudo  \btrfs  filesystem  defrag \
  -clzo   ` # Compress, with lzo ` \
  -f      ` # Fluch data after defragmenting ` \
  -r      ` # Recursive ` \
  -v      ` # Verbose ` \
` # `



# Method two..
\find -xdev -type f -exec \
  \sudo  \btrfs  filesystem  defrag \
    -clzo \
    -f \
    -v \
    '{}' \;

