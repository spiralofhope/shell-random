#!/usr/bin/env  sh


# Compress a file and append the date and time to its filename.
# Note that 7-zip does not store the owner/group of the file.


date_and_time=` \date  --utc  +'%Y-%m-%d_%H-%M' `
filename="$1"__"$date_and_time".7z

\7z  a  \
  ` # maximum compression ` \
  -mx9 \
  "$filename" \
  "$1"
