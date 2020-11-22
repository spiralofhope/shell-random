#!/usr/bin/env  sh

# The "md5" command in NetBSD 3.0 does not support the "-c" option for automatically checking MD5 sums. The following script will allow you to automatically check MD5 sums. 

# Untested

# Modified from:
#   https://web.archive.org/web/20070905040824/http://wiki.netbsd.se/index.php/Shell-Hacks#Create_GUI_applications_from_the_shell



MSG="No error(s) encountered! Yay!"
while read -r line; do
  PTHCHK=$( echo "$line" | sed -e 's/MD5\ (//; s/)\ =\ \([0-9a-f]\{32\}\)$/:\1/' )
  MD5PATHNAME=${PTHCHK%%:*}
  MD5CHECKSUM=${PTHCHK##*:}
  if [ -f "$MD5PATHNAME" ]; then
    F=$( md5 "$MD5PATHNAME" | sed -e 's/MD5\ (//; s/)\ =\ \([0-9a-f]\{32\}\)$/:\1/' )
    CHECKSUM=${F##*:}
  if [ "$MD5CHECKSUM" = "$CHECKSUM" ]; then
    echo "$MD5CHECKSUM = $CHECKSUM ($MD5PATHNAME) -- ok!"
  else
    echo "$MD5CHECKSUM != $CHECKSUM ($MD5PATHNAME) -- error!"
    MSG="ERRORS ENCOUNTERED!! Oh, noo!"
  fi
  else
    echo "File not found: $MD5PATHNAME"
    MSG="ERRORS ENCOUNTERED!! Oh, noo!"
  fi
done <"$1"
echo "$MSG"
