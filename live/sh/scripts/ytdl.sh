#!/usr/bin/env  sh

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
# Remove trailing periods
#   (They are invalid on NTFS)
target_subdirectory=$( \echo  "$target_subdirectory"  |  \sed  's/\.$//' )
# I have no idea how to use youtube-dl's --output to fix the date format, so I define the directory manually.
# 20170515  =>  2017-05-15
target_subdirectory=$( \echo  "$target_subdirectory"  |  \sed  's/\(^[0-9]\{4\}\)\([0-9]\{2\}\)/\1-\2-/' )
#
#\echo  "$target"
#\echo  "$target_directory"
#\echo  "$target_subdirectory"
#\echo  "$target_files"
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


# Deal with long filenames.
# FIXME - just truncate the existing variable's content.
if [ ${#target_directory}    -gt 20 ]; then target_directory=$(    \basename $( \mktemp  --dry-run ) ); fi
if [ ${#target_subdirectory} -gt 20 ]; then target_subdirectory=$( \basename $( \mktemp  --dry-run ) ); fi

\mkdir  --parents  --verbose  "$target_directory/$target_subdirectory"  ||  exit  $?
\cd                           "$target_directory/$target_subdirectory"  ||  exit  $?


# Previously..
#    ` # Note that a base directory  ./  does not work (for subtitles) `  \
#    --output '%(uploader)s/%(upload_date)s - %(title)s/%(title)s.%(ext)s'  \
#
#` # I suspect this is important for an NTFS filesystem. `  \
#--restrict-filenames  \
#
if  !  \
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
then
  exit $?
fi



# Also download comments using  `youtube-comment-scraper`
# This script will pick up the data from v.info.json
ytcs.sh
