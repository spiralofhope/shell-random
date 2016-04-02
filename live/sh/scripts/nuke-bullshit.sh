#! /usr/bin/env  sh



# TODO - There has to be a better way to do this.
# .DS_Store
# .BridgeCache
# .BridgeCacheT
# Thumbs.db



\find  -type f  -name '.DS_Store'     -delete
\find  -type f  -name '.BridgeCache'  -delete
\find  -type f  -name '.BridgeCacheT' -delete
\find  -type f  -name 'Thumbs.db'     -delete
