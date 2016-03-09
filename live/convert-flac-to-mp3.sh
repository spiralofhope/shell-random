#!/usr/bin/env  bash



# TODO - Figure out how to convert to ogg.  My passing attempt failed and I gave up too easily.
# TODO - Adapt this to convert .ape files.  It seems that the avconv string will work.

# If the source is one big .flac file, and you have a .cue file to work with.
#   1.  Convert it via this script
#   2.  Split the mp3:
#     \sudo  \apt-get  install  mp3splt
#     \mp3splt  -c file.cue  bigfile.mp3
#   [Yes, it's mp3splt and not mp3split, because that would make too much sense.]


_convert_flac_to_mp3() {
  \echo  ''
  \echo  'Note:  Adding _ to identify this as a transcoded item.'
  \echo  'Note:  Adding = to identify this as self-created mp3.'
  # Note that  \avconv  is a drop-in replacement for the depreciated  \ffmpeg
  \avconv \
    -i "$1" \
    -qscale:a 0 \
    "$2"
  if [[ $? -ne 0 ]]; then
    \echo  'pausing..'
    read  __
  fi
}



_convert_vbrfix() {
  \echo  ''
  \echo  ' * Fixing the mp3 length..'
  working_filename=ripping_temp.$$."$audio_codec"

  \vbrfix  -always  -makevbr  "$1"  $working_filename

  \mv  --force  $working_filename  "$1"
  \rm  --force  vbrfix.log  vbrfix.tmp
}



if [ -z $1 ]; then
  \echo  ''
  \echo  ' * Converting all flac files in the current directory..'
  for i in *.flac; do
    # Seems like a straightforward way to bail out.
    if [[ $i == "*.flac" ]]; then
      \echo  'ERROR:  No .flac files found.'
      continue
    fi
    output_filename="${i/%.flac/ =_.mp3}"
    _convert_flac_to_mp3  "$i"  "$output_filename"
    _convert_vbrfix              "$output_filename"
  done
else
    output_filename="${@/%.flac/ =_.mp3}"
    _convert_flac_to_mp3  "$1"  "$output_filename"
    _convert_vbrfix             "$output_filename"
fi
