#!/bin/sh
# 



DRY_MODE='true'



#:<<'}'   #  Taken from  `replace-basename.sh`
_basename() {
  dir=${1%${1##*[!/]}}
  dir=${dir##*/}
  dir=${dir%"$2"}
  printf '%s\n' "${dir:-/}"
}



# In case you don't have system-specified MIME files, or you want to override content in them:
fallback_temporary_mime_file="/tmp/$( _basename  "$0" )-mime_types.$$.txt"
\cat > "$fallback_temporary_mime_file" << HERE_DOCUMENT
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
HERE_DOCUMENT
# Automatically clean up the temporary file on exit, error, control-c, etc.
# See  `trapping-signals.sh`
_teardown()  {
  \rm  --force  "$fallback_temporary_mime_file"
  exit
  for  signal  in  INT QUIT HUP TERM EXIT; do
    trap  -  "$signal"
  done
}
trap  _teardown  INT QUIT HUP TERM EXIT



_find_extension() {
  filename_to_check="$1"
  mime_types_file="$2"
  #
  if [ ! -f "$mime_types_file"   ]; then  return  1; fi
  if [ ! -f "$filename_to_check" ]; then  return  1; fi
  mime_type=$( \file  --brief  --mime-type  "$filename_to_check" )
  # \echo  -n "$mime_type \t $file\n"
  extension_detected="$( \awk -v mime="$mime_type" '
    $0 ~ /^[[:space:]]*#/ { next }  # Skip lines starting with #
    $0 ~ /^[[:space:]]*$/ { next }  # Skip blank lines
    $1 == mime { print $2 }' "$mime_types_file" )"
  if [ -z "$extension_detected" ]; then
#    \echo  " * ERROR:  MIME file \"$mime_types_file\" has no type for:  \"$filename_to_check\""  >&2
   return  1
 fi
 # \echo  "Detected extension: $extension_detected"
}



# TODO - Allow the user to specify a filename.  If not specified, then iterate through *
for file in *; do
  if [ ! -f "$file" ]; then
    \echo  "Skipping non-directory \"$file\""  >&2
    continue
  fi
  #
  # Bottom takes priority:
  _find_extension  "$file"  '/etc/mime.types'
  # Has no extensions:
  #_find_extension  "$file"  '/usr/share/mime/types'
  _find_extension  "$file"  "$fallback_temporary_mime_file"
  if [ -z "$extension_detected" ]; then
    \echo  " * ERROR:  No extension found:"  >&2
    \echo  "   $file"  >&2
    \echo  "   $mime_type"  >&2
    continue
  fi
  #
  file_basename="$( _basename "$file" )"
  extension_current="${file_basename##*.}"
  file_basename="${file_basename%.*}"
  file_new_name="./$file_basename.$extension_detected"
  #
  if [ "$extension_current" = "$extension_detected" ]; then
    \echo  "Skipping correct extension for:  $file"  >&2
    continue
  fi
  #
  if [ "$DRY_MODE" = 'true' ]; then
    \echo  "\mv  --verbose  \"$file\" \"$file_new_name\"  (DRY RUN)"  >&2
    continue
  fi
  # The stars have aligned.
  \mv  --verbose  "$file"  "$file_new_name"
done
