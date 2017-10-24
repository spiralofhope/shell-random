#!/usr/bin/env sh



debug=true
verbose='--verbose'


# Requirements:
# avconv (libav)
#   http://libav.org/
# Note that  \avconv  is a drop-in replacement for the deprecated  \ffmpeg



{  # source expanded path
  input="$1"
  source_file="$( \realpath "$input" )"

  if [ $debug ]; then
    \echo  'source is:'
    \echo  "$source_file"
  fi
}


{  # target expanded path
  directory_without_file="$( \dirname "$source_file" )"
  filename="$( \basename "$source_file" )"
  filename_without_path_or_extension="${filename%.*}"
  append=" _.mp3"
  target_file="${directory_without_file}/${filename_without_path_or_extension}${append}"

  if [ $debug ]; then
    \echo  'target is:'
    \echo  "$target_file"
  fi
}


{  # transcode
  \echo  ' * Transcoding..'
  # If avconv isn't found:
  # On Devuan-1.0.0-jessie-i386-DVD:
  #   apt-get install libav-tools
  \avconv  -i "$source_file"  -aq 3  "$target_file"
  \echo  ''
}


{  # vbr fix
  \echo  ' * Fixing the mp3 length..'
  # TODO - Use a proper temporary file.
  append=.$$
  temp_filename="${target_file}${append}"
  if [ $debug ]; then
    \echo  'temp file is:'
    \echo  "$temp_filename"
  fi
  \vbrfix  -makevbr  "$target_file"  "$temp_filename"
  if [ $? -eq 0 ]; then
    \mv  --force  $verbose  "$temp_filename"  "$target_file"
    \rm  --force  $verbose  vbrfix.log  vbrfix.tmp
  fi
  \echo  ''
}
