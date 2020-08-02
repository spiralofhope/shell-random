#!/usr/bin/env  sh
# shellcheck disable=1083
#   I like using backslashes.
# shellcheck disable=1001
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
# YouTube's supported subtitle and closed caption files:
#   https://support.google.com/youtube/answer/2734698


#DEBUG='true'


:<<'# For autotest.sh'
if [ -z "$@" ]; then
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



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}


# INT is ^C
trap control_c INT
control_c()
{
  \echo  'control-c detected.'
  exit  0
}


case  "$#"  in
  0)
    \youtube-dl
    exit  0
  ;;
  2)
    if [ "$2" = '-F' ]; then
      \youtube-dl  "$@"
      exit  0
    fi
    # Else continue onward, using use $2 as the parameter.
  ;;
esac
_debug  "$# parameter(s):"
_debug  "$@"



#target='some creator name/20170515 - the video title./the filename.mp4'
#:<<'}'   #  Get the directory, subdirectory and filename
{
  target=$(  \
    \youtube-dl  \
      --get-filename  \
      --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
    "$@"  \
  )  || exit  $?
  # Sometimes youtube-dl will give an error, e.g.:
  #   "ERROR: jNQXAC9IVRw: YouTube said: Unable to extract video data"
  # 2020-08-01  --  An age restricted video will give an error.  I am unable to log in with either --username or ~/.netrc (and --netrc), and I get:
  #   "WARNING: Unable to look up account info: HTTP Error 404: Not Found"
  #if [ $? -ne 0 ]; then exit $?; fi
}
target_directory="$(    \dirname  "$( \dirname  "$target" )" )"
target_subdirectory="$( \basename "$( \dirname  "$target" )" )"
_debug  "target:               $target"
_debug  "target_directory:     $target_directory"
_debug  "target_subdirectory:  $target_subdirectory"
#
# TODO - remove any other invalid characters
# Remove 1-3 trailing periods
#   (They are invalid on NTFS)
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
target_subdirectory=$( printf  '%s\n'  "${target_subdirectory%%.}" )
# I have no idea how to use youtube-dl's --output to fix the date format, so I define the directory manually.
# 20170515  =>  2017-05-15
# TODO - replace \sed
target_subdirectory=$( \echo  "$target_subdirectory"  |  \sed  's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
_debug  "target_subdirectory:  $target_subdirectory"

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

if_long_then_truncate_and_append() {
  string_length_maximum="$1"
  shift
  # $2*
  string="$*"
  string_length=${#string}
  if [ "$string_length" -gt "$string_length_maximum" ]; then
    append='…'
  fi
  __=$( string-truncate.sh  "$string_length_maximum"  "$string" )
  \echo  "$__$append"
}
target_directory="$(     if_long_then_truncate_and_append  29  "$target_directory"    )"
target_subdirectory="$(  if_long_then_truncate_and_append  59  "$target_subdirectory" )"
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
\youtube-dl  \
  --console-title  \
  --audio-format  best  \
  --write-info-json  \
  --write-annotations  \
  --write-all-thumbnails  --embed-thumbnail  \
  --all-subs  --embed-subs  \
  --add-metadata  \
  --no-call-home  \
  --output  'v.%(ext)s'  \
  "$@"

# For some stupid reason the description file won't be properly downloaded if placed in the above statement.
\youtube-dl  \
  --skip-download  \
  --write-description  \
  --output  'v.%(ext)s'  \
  "$@"
\mv  'v.description'  'v.description.txt'


if [ -f 'v_4.webp' ]; then
  _debug  ' * Deleting extraneous thumbnails.'
  \rm  --force  v_*.jpg
fi
if [ -f 'v_3.jpg' ]; then
  _debug  ' * Deleting extraneous thumbnails.'
  \rm  --force  v_0.jpg
  \rm  --force  v_1.jpg
  \rm  --force  v_2.jpg
fi
if [ -f 'v_4.jpg' ]; then
  _debug  ' * Deleting extraneous thumbnails.'
  \rm  --force  v_3.jpg
fi



if  [ "$DEBUG" = 'true' ] || \
    [ $# -eq 2 ] && [ "$2" = '-F' ]; then
  exit
fi
# Also download comments using  `youtube-comment-scraper`
# This script will pick up the data from v.info.json
ytcs.sh


\echo  ''
\echo  " * Finished with:"
\echo  "   $target_directory"
\echo  "   $target_subdirectory"
\echo  ''
