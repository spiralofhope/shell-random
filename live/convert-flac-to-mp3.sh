#!/bin/bash
# TODO - figure out how to convert to ogg.  My passing attempt failed and I gave up too easily.



_convert_flac_to_mp3() {
  \echo  "Note:  Adding _ to identify this as a transcoded item."
  # Note that  \avconv  is a drop-in replacement for the depreciated  \ffmpeg
  \avconv \
    -i "$1" \
    -qscale:a 0 \
    "$2"
  if [[ $? -ne 0 ]]; then
    read  __
  fi
}



_convert_vbrfix() {
  \echo  " * Fixing the mp3 length.."
  working_filename=ripping_temp.$$."$audio_codec"

  \vbrfix  -always  -makevbr  "$1"  $working_filename

  \mv  --force  $working_filename  "$1"
  \rm  --force  vbrfix.log  vbrfix.tmp
}



if [[ $1 == "" ]]; then
  for i in *.flac; do
    # Seems like a straightforward way to bail out.
    if [[ $i == "*.flac" ]]; then
      \echo  "ERROR:  No .flac files found."
      continue
    fi
    output_filename="${i/%.flac/ _.mp3}"
    _convert_flac_to_mp3  "$i"  "$output_filename"
    _convert_vbrfix              "$output_filename"
  done
else
    output_filename="${@/%.flac/ _.mp3}"
    _convert_flac_to_mp3  "$1"  "$output_filename"
    _convert_vbrfix             "$output_filename"
fi
