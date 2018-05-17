#!/usr/bin/env  sh



# Be wary of indentation.
array='
.DS_Store
.BridgeCache
.BridgeCacheT
Thumbs.db
desktop.ini
'


for i in "$array"; do
  echo "$i"
done
