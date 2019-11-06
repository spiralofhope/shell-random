#!/usr/bin/env  sh



# 2019-11-05 - Tested on Debian 10.1.0-amd64-xfce-CD-1 with:
#   dash 0.5.10.2-5
#   7:4.1.4-1~deb10u1
debug=true

# Requirements:
# ffmpeg
#   https://ffmpeg.org/

# Note that "avconv" is a drop-in replacement for ffmpeg
# avconv (libav)
#   http://libav.org/



first_word(){
  \echo  "$@"  |  \cut  --delimiter=' '  --fields=1
}



debug() {
  if [ $debug ]; then
    \echo  $*
  fi
}



#:<<'}'   # source expanded path
{
  input="$1"
  source_file="$( \realpath "$input" )"

  debug  'source is:'
  debug  "$source_file"
}



#:<<'}'   # target expanded path
{
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
  __=$( first_word  "$audio_codec" )
  if [ "$__" = 'aac' ]; then
    append='.aac'
    debug  "appending .aac"
  else
    append=".${audio_codec}"
  fi

  target_file="${directory_without_file}/${filename_without_path_or_extension}${append}"

  debug  'target is:'
  debug  "$target_file"
}



#:<<'}'   #  rip
{
  \ffmpeg \
    -i "$source_file" \
    -acodec copy \
    "$target_file" \
  ` # `
}
