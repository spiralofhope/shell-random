#!/usr/bin/env  sh

# Download just the largest-quality thumbnail.
# Note that this is already done within youtube-download.sh

# TODO - Test cookie functionality.



#cookie_file="$HOME/netscape-cookies.txt"
#DEBUG='true'



#:<<'}'   #  For `autotest.sh`
{
  if [ $# -eq 0 ]; then
    # Pass example parameters to this very script:
    # This is the oldest YouTube video:
    "$0"  'jNQXAC9IVRw'
    #"$0"  'https://youtu.be/jNQXAC9IVRw'
    #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw'
    #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw#me-at-the-zoo'

    # Testing with a login required...
    # TODO - Upload my own test, so I can rely on its existence.
    #"$0"  'ufH4DaUxBbA'

    return
  fi

  # TODO - instructions
  #if   [ "$#" -ne 1 ]; then return  1; fi
}



video_id="$1"
shift



# INT is ^C
trap control_c INT
control_c()
{
  \echo  'control-c detected.'
  exit  0
}



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}



cookie_file=${cookie_file=''}
if [ ! "$cookie_file" = '' ]  \
&& [ ! -e "$cookie_file" ]
then
  \echo  'cookie file not found'
  exit  1
fi



_get_thumbnail() {
  if [ "$cookie_file" = '' ]; then
    \youtube-dl  \
      --skip-download  \
      --write-all-thumbnails  --embed-thumbnail  \
      --no-call-home  \
      --output  'v.%(ext)s'  \
      "$@"  \
      --  \
      "$video_id"
  else   #  use cookies
    \youtube-dl  \
      --cookies="$cookie_file"  \
      --skip-download  \
      --write-all-thumbnails  --embed-thumbnail  \
      --no-call-home  \
      --output  'v.%(ext)s'  \
      "$@"  \
      --  \
      "$video_id"
  fi
}



_get_thumbnail
# Because I don't know how to download just the big thumbnail.
youtube-dl_delete-extraneous-thumbnails.sh
