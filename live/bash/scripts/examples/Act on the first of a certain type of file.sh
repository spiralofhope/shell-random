#!/usr/bin/env  bash



# New hotness

# gpicview `ls *.bmp *.gif *.jpg *.png | sed q`&



EXTENSIONS=( .jpg .gif .png .bmp )
COMMAND=`which gpicview`


if [ -a /tmp/temp.$PPID ]; then
  rm -f /tmp/temp.$PPID
fi

# iterate through the array of extensions.
for element in ${EXTENSIONS[@]} ; do
  # build one big list of matching files.
  ls *$element>>/tmp/temp.$PPID
done

exec $COMMAND `sort < /tmp/temp.$PPID | sed q`

if [ -a /tmp/temp.$PPID ]; then
  rm -f /tmp/temp.$PPID
fi
