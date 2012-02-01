# Purge the disk cache:
kill -USR1 `cat "/tmp/polipo.pid"`
sleep 1
polipo -x diskCacheRoot="/tmp/polipo/"
kill -USR2 `cat "/tmp/polipo.pid"`

