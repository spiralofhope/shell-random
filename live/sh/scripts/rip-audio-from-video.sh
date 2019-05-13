#!/usr/bin/env  sh



# 2017-10-23 - Tested on Devuan-1.0.0-jessie-i386-DVD with:
#   dash 0.5.7-4
#   libav 6:11.9-1~deb8u1
#debug=true



# Requirements:
# avconv (libav)
#   http://libav.org/
# Note that  \avconv  is a drop-in replacement for the \ffmpeg



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

  {  # Learn the codec being used:
    audio_codec="$( \
      \ffmpeg  -i "$source_file"  2>&1 |\
      \sed  --quiet  's/.* Audio: \([^,]*\).*/\1/p' \
    )"

    debug  'audio_codec is:'
    debug  "$audio_codec"
  }
  append=".${audio_codec}"

  target_file="${directory_without_file}/${filename_without_path_or_extension}${append}"

  debug  'target is:'
  debug  "$target_file"
}



{  # rip
  \ffmpeg \
    -i "$source_file" \
    -acodec copy \
    "$target_file" \
  ` # `
}
