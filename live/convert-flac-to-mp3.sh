#!/bin/bash


_convert_setup() {
  output_filename="${@/%.flac/ _.mp3}"
}


_convert_vbrfix() {
  \echo  " * Fixing the mp3 length.."
  working_filename=ripping_temp.$$."$audio_codec"

  \vbrfix  -always  -makevbr  "$1"  $working_filename

  \mv  --force  $working_filename  "$1"
  \rm  --force  vbrfix.log  vbrfix.tmp
}



# Note that  \avconv  is a drop-in replacement for the depreciated  \ffmpeg
_convert_flac_to_ogg() {
  \echo  "Note:  Adding _ to identify this as a transcoded item."
  \avconv \
    -i "$1" \
    -qscale:a 0 \
    "$2"
}



_convert_setup        "$1"
_convert_flac_to_ogg  "$1"  "$output_filename"
_convert_vbrfix       "$output_filename"
