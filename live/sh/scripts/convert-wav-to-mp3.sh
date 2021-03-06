#!/usr/bin/env  sh


source=$1
# TODO - remove the .wav
target="$1 =_.mp3"



_convert() {
  \echo  'Note:  Adding _ to identify this as a transcoded item.'
  \echo  'Note:  Adding = to identify this as self-created mp3.'
  if  !  \
    \lame  -V0  "$source"  "$target"
  then
    exit 1
  fi
}


_vbrfix() {
  \echo  ' * Fixing the mp3 length..'
  working_filename="$target.ripping_temp.$$.mp3"

  if  !  \
    \vbrfix  -always  -makevbr  "$target"  "$working_filename"
  then
    exit 1
  fi

  \mv  --force  "$working_filename"  "$target"
  \rm  --force  vbrfix.log  vbrfix.tmp
}



# --
# -- The actual work
# --

_convert   "$1"
_vbrfix    "$target"
