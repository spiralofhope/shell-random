# This can't deal with the first jpg have a space in the filename.
# Spits out an error.
# exec gpicview `ls "*.bmp" "*.gif" "*.jpg" "*.png" | sed q "$1"`&
# At least this one doesn't give an error... but it doesn't work on stuff with no space.  HAH
# exec 'gpicview `ls "*.bmp" "*.gif" "*.jpg" "*.png" | sed q "$1"`'&
# opens a blank window..
# sh -c 'gpicview `ls "*.bmp" "*.gif" "*.jpg" "*.png" | sed q "$1"`'&
# Does nothing..
exec gpicview `ls *.bmp *.gif *.jpg *.png" | sed q`&


:<<DOESNOTWORK

EXTENSIONS=( .jpg .gif .png .bmp )
COMMAND=`which gpicview`

if [ -a /tmp/temp.$PPID ]; then
  rm -f /tmp/temp.$PPID
fi

# iterate through the array of extensions.
for element in ${EXTENSIONS[@]} ; do
  # build one big list of matching files.
  ls *"$element">>/tmp/temp.$PPID
done

exec "$COMMAND" `sort < /tmp/temp.$PPID | sed q`

if [ -a /tmp/temp.$PPID ]; then
  rm -f /tmp/temp.$PPID
fi
