#!/usr/bin/env  sh
# A helper for the program `vbrfix`
#   .. because it's stupid.



_go() {
  file_source="$1"
  \echo  " * VBR fixing:  $file_source"
  local  tempfile=$( \mktemp  --suffix=".transcode-audio-into-mp3.$$" )
  \vbrfix  -always  -makevbr  "$file_source"  $tempfile
  \mv  --force  $tempfile  "$file_source"
  \rm  --force  $verbose  vbrfix.log  vbrfix.tmp  $tempfile
}



if [ -z $1 ]; then
  for i in *.mp3; do
    _go  "$i"
  done
else
  _go  "$1"
fi
