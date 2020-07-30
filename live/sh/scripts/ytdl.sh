#!/usr/bin/env  sh
# shellcheck disable=1083
#   I like using backslashes.

# Download YouTube and other videos.
#
# Uses youtube-dl:
#   https://youtube-dl.org/
#   https://blog.spiralofhope.com/?p=41260
#
# TODO - Requires my `search-JSON.sh`.
#
# Optionally uses my `ytcs.sh` to scrape YouTube comments.
#
# TODO/FIXME - I want to also download subtitles, but `search-JSON.sh` does not support the complexity required.
# YouTube's supported subtitle and closed caption files:
#   https://support.google.com/youtube/answer/2734698


#DEBUG='true'


:<<'# For autotest.sh'
if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  # This is the oldest YouTube video:
  #"$0"  'jNQXAC9IVRw'                                                --skip-download
  #"$0"  'https://youtu.be/jNQXAC9IVRw'                               --skip-download
  #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw'                --skip-download
  "$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw#me-at-the-zoo'  --skip-download
  # =>
  # amp
  return
fi


# TODO - instructions
if   [ "$#" -ne 1 ]; then return  1; fi
# For autotest.sh



# INT is ^C
trap control_c INT
control_c()
{
  \echo  'control-c detected.'
  exit  0
}



if [ "x$2" = 'x-F' ]; then
  \youtube-dl  "$@"
  exit
fi


DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}


#target='some creator name/20170515 - the video title./the filename.mp4'
#:<<'}'   #  Get the directory, subdirectory and filename
{
  target=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
    "$@"  \
  )
}
target_directory="$(    \dirname  "$( \dirname  "$target" )" )"
target_subdirectory="$( \basename "$( \dirname  "$target" )" )"
# Unused:
#target_files="$(                      \basename "$target" )"
#
# TODO - remove any other invalid characters
# Remove 1-3 trailing periods
#   (They are invalid on NTFS)
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
# I have no idea how to use youtube-dl's --output to fix the date format, so I define the directory manually.
# 20170515  =>  2017-05-15
target_subdirectory=$( \echo  "$target_subdirectory"  |  \sed  's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
#
_debug  "$target"
_debug  "$target_directory"
_debug  "$target_subdirectory"
_debug  "$target_files"
#exit
#
:<<'}'   #  Get everything separately
        # This might be more reliable (maybe videos have a slash in their name?), but it's slower and multiple scrapes might piss YouTube off.
  target_directory=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(uploader)s'  \
    "$@"  \
  )
  target_subdirectory=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(upload_date)s - %(title)s'  \
    "$@"  \
  )
  #target_files=$(  \
    #\youtube-dl  \
      #--get-filename  \
      #--output '%(title)s.%(ext)s'  \
    #"$@"  \
  #)
}


# Taken from  `string-truncate.sh`
string_truncate() {
  string_length_maximum="$1"
  shift
  string="$*"
  string_length=${#string}
  #
  _debug  "String:                   $string"
  _debug  "  String length:          $string_length"
  _debug  "  String length maximum:  $string_length_maximum"
  #
  if [ "$string_length" -le "$string_length_maximum" ]; then
    _debug  "  (not truncating)"
    \echo  "$string"
  else
    # See  `iterate-over-characters-in-a-string.sh`
    __="$string"
    #
    while [ -n "$__" ]; do
      rest="${__#?}"
      first_character="${__%"$rest"}"
      result="$result$first_character"
      __="$rest"
      #
      if [ ${#result} -eq "$string_length_maximum" ]; then
        # NOTE - adding an ellipsis
        \echo  "$result"…
        break
      fi
    done
    _debug  "  Length is greater than:   $string_length_maximum"
    _debug  "  Truncating string to:     $result"
  fi
}
#
target_directory="$(    string_truncate  29  "$( \basename  "$target_directory" )" )"
target_subdirectory="$( string_truncate  59  "$( \basename  "$target_subdirectory" )" )"

_debug  "$target_directory"
_debug  "$target_subdirectory"

\mkdir  --parents  --verbose  "$target_directory/$target_subdirectory"  ||  exit  $?
\cd                           "$target_directory/$target_subdirectory"  ||  exit  $?


# Previously..
#    ` # Note that a base directory  ./  does not work (for subtitles) `  \
#    --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
#
#` # I suspect this is important for an NTFS filesystem. `  \
#--restrict-filenames  \
#
# AtomicParsley began throwing an error.
#if  !  \
  #
  \youtube-dl  \
    --console-title  \
    --audio-format  best  \
    --write-description  \
    --write-info-json  \
    --write-annotations  \
    --write-all-thumbnails  --embed-thumbnail  \
    --all-subs  --embed-subs  \
    --add-metadata  \
    --no-call-home  \
    --output 'v.%(ext)s'  \
    -f best  \
    "$@"
#then
  #exit  $?
#fi



# Also download comments using  `youtube-comment-scraper`
# This script will pick up the data from v.info.json
ytcs.sh
