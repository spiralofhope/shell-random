#!/bin/sh



DRY_MODE='true'



#:<<'}'   #  Taken from  `replace-basename.sh`
_basename() {
  dir=${1%${1##*[!/]}}
  dir=${dir##*/}
  dir=${dir%"$2"}
  printf '%s\n' "${dir:-/}"
}



fallback_temporary_mime_file="/tmp/$( _basename  "$0" )-mime_types.$$.txt"
: <<EOF > "$fallback_temporary_mime_file"
application/pdf pdf
application/vnd.rn-realmedia rm
audio/mpeg mp3
audio/x-wav wav
image/gif gif
image/jpeg jpg
image/png png
text/plain txt
text/x-shellscript sh
video/mp4 mp4
video/ogg ogg
video/webm webm
EOF

# Preferred are at the bottom
_="$fallback_temporary_mime_file" ; if [ -f "$_" ]; then  MIME_FILE="$_";  fi
_='/usr/share/mime/types'         ; if [ -f "$_" ]; then  MIME_FILE="$_";  fi
_='/etc/mime.types'               ; if [ -f "$_" ]; then  MIME_FILE="$_";  fi




for FILE in *; do
  if [ ! -f "$FILE" ]; then  continue;  fi

  MIME_TYPE=$( \file  --brief  --mime-type  "$FILE" )

  \echo  -n "$MIME_TYPE \t $FILE\n"

  EXT="$( \awk -v mime="$MIME_TYPE" '
    $0 ~ /^[[:space:]]*#/ { next }  # Skip lines starting with #
    $0 ~ /^[[:space:]]*$/ { next }  # Skip blank lines
    $1 == mime { print $2 }' "$MIME_FILE" )"

  # Check if an extension was found
  if [ -n "$EXT" ]; then
    BASE_NAME="$( _basename "$FILE" )"
    CURRENT_EXT="${BASE_NAME##*.}"
    BASE_NAME="${BASE_NAME%.*}"
    NEW_FILE="./$BASE_NAME.$EXT"
    if [ "$CURRENT_EXT" != "$EXT" ]; then
      if [ "$DRY_MODE" = 'true' ]; then
        \echo  "\mv  --verbose  \"$FILE\" \"$NEW_FILE\"  (DRY RUN)"
      else
        \mv  --verbose  "$FILE" "$NEW_FILE"
      fi
    else
      \echo  "Skipping correct extension for:  $FILE"
    fi
  else
    \echo  " * ERROR:  Unknown MIME type or no matching extension found for:  $FILE"
  fi
done


\rm  --force  --verbose  "$fallback_temporary_mime_file"
