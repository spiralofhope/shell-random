#!/usr/bin/env  sh
# Transcode an audio file into mp3.
#   Note that while this could be used directly on a video, it will be terribly slow.  Instead:  transcode the file resulting from `rip-audio-from-video.sh`


# Requirements:
# ffmpeg
#   https://ffmpeg.org/


# Note that  \avconv  (libav) is a drop-in alternative.
#   On Devuan-1.0.0-jessie-i386-DVD:
#     apt-get install libav-tools
#
#
# 2017-10-23 - Tested on Devuan-1.0.0-jessie-i386-DVD with:
#   dash 0.5.7-4
#   libav 6:11.9-1~deb8u1



#debug=true
#verbose='--verbose'
debug() {
  if [ $debug ]; then
    \echo  "$*"
  fi
}



#:<<'}'   #  source expanded path
{
  input="$1"
  file_source="$( \realpath "$input" )"

  debug  'source is:'
  debug  "$file_source"
}


#:<<'}'   #  target expanded path
{
  directory_without_file="$( \dirname "$file_source" )"
  filename="$( \basename "$file_source" )"
  filename_without_path_or_extension="${filename%.*}"
  append=" _.mp3"
  file_target="${directory_without_file}/${filename_without_path_or_extension}${append}"

  debug  'target is:'
  debug  "$file_target"
}


#:<<'}'   #  Transcode
{
  \echo  ' * Transcoding..'
  \echo  '   Warnng:  This is lossy!'
  \ffmpeg  \
    -i "$file_source"  \
    -aq 3  \
    "$file_target"  \
  ` # `
  \echo  ''
}


#:<<'}'   #  VBR fix
{
  # (directly lifted from `vbrfixit.sh`)
  \echo  " * VBR fixing:  $file_source"
  tempfile=$( \mktemp  --suffix=".transcode-audio-into-mp3.$$" )
  \vbrfix  -always  -makevbr  "$file_source"  "$tempfile"
  \mv  --force  "$tempfile"  "$file_source"
  \rm  --force  "$verbose"  vbrfix.log  vbrfix.tmp  "$tempfile"
}
