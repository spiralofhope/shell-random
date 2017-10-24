#!/usr/bin/env  sh



# Transcode an audio file into mp3.
# While this could be used directly on a video, it will be terribly slow.  Instead:  transcode the file resulting from `rip-audio-from-video.sh`


# 2017-10-23 - Tested on Devuan-1.0.0-jessie-i386-DVD with libav 6:11.9-1~deb8u1
#debug=true
#verbose='--verbose'


# Requirements:
# avconv (libav)
#   http://libav.org/
# Note that  \avconv  is a drop-in replacement for the deprecated  \ffmpeg



debug() {
  if [ $debug ]; then
    \echo  $*
  fi
}



{  # source expanded path
  input="$1"
  source_file="$( \realpath "$input" )"

  debug  'source is:'
  debug  "$source_file"
}


{  # target expanded path
  directory_without_file="$( \dirname "$source_file" )"
  filename="$( \basename "$source_file" )"
  filename_without_path_or_extension="${filename%.*}"
  append=" _.mp3"
  target_file="${directory_without_file}/${filename_without_path_or_extension}${append}"

  debug  'target is:'
  debug  "$target_file"
}


{  # transcode
  \echo  ' * Transcoding..'
  # If avconv isn't found:
  # On Devuan-1.0.0-jessie-i386-DVD:
  #   apt-get install libav-tools
  \avconv \
    -i "$source_file" \
    -aq 3 \
    "$target_file" \
  ` # `
  \echo  ''
}


{  # vbr fix
  \echo  ' * Fixing the mp3 length..'
  # TODO - Use a proper temporary file.
  append=.$$
  temp_filename="${target_file}${append}"
  debug  'temp file is:'
  debug  "$temp_filename"
  \vbrfix  -makevbr  "$target_file"  "$temp_filename"
  if [ $? -eq 0 ]; then
    \mv  --force  $verbose  "$temp_filename"  "$target_file"
    \rm  --force  $verbose  vbrfix.log  vbrfix.tmp
  fi
  \echo  ''
}
