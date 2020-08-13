#!/usr/bin/env  sh
# shellcheck disable=1001
  # I like my backslashes.

# Compress a file and append the date and time to its filename.
# Note that 7-zip does not store the owner/group of the file.
# TODO - just leverage 7zip-compress-file.sh


date_hours_minutes=$( \date.sh  'minutes'  )
filename="$1"__"$date_hours_minutes".7z

\7z  a  \
  "` # maximum compression `" \
  -mx9 \
  "$filename" \
  "$1"
