#!/usr/bin/env  bash



# New hotness

# gpicview  $( \ls *.bmp *.gif *.jpg *.png | \sed  q )&



EXTENSIONS=( .jpg .gif .png .bmp )
COMMAND="$( \realpath  gpicview )"



tempfile=$( \mktemp  --suffix=".my_temporary_file.$$" )
  
# iterate through the array of extensions.
for element in "${EXTENSIONS[@]}" ; do
  # build one big list of matching files.
  \ls  ./"*$element" >> "$tempfile"
done

$COMMAND  $( \sort < "$tempfile" | \sed  q )

\rm  --force  "$tempfile"
