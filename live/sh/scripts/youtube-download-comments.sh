#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
#   (I like backslashes)

# Scrape comments from YouTube videos.
#
# Requires my `search-JSON.sh`.


# TODO - I want to detect signals and abort the download without killing autotest.sh, but Python's KeyboardInterrupt is too aggressive or something..
# TODO - don't try to download comments for non-YouTube.  Obviously.
# TODO - Abort without http://
# TODO - also edit download-description since that won't work everywhere?


#DEBUG='true'



:<<'# For autotest.sh'
if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  # This is the oldest YouTube video:
  #"$0"  'jNQXAC9IVRw'
  #"$0"  'https://youtu.be/jNQXAC9IVRw'
  #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw'
  #"$0"  'https://www.youtube.com/watch?v=jNQXAC9IVRw#me-at-the-zoo'
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
    \echo  "$*"  >&2
  fi
}


if   [ "$#" -eq 1 ]; then
  source_video_id="$1"
  source_video_id=$( printf  '%s\n'  "${source_video_id##*/}" )
  source_video_id=$( printf  '%s\n'  "${source_video_id##watch?v=}" )
  source_video_id=$( printf  '%s\n'  "${source_video_id%%#*}" )
elif  \stat  --printf=''  ./*.info.json  2> /dev/null; then
  _debug  " * Found a JSON file"
  source_video_id="$( \search-json.sh  'id'  ./*.info.json )"
elif  \stat  --printf=''  comments\ -\ *.ytcs1.csv  2> /dev/null; then
  _debug  " * Found a youtube-comment-scraper CSV file"
  for filename in comments\ -\ *.ytcs1.csv; do
    source_video_id=$( \replace-cut.sh  ' '  3  "$filename" )
    # Only process the first file found:
    break
  done
elif  \stat  --printf=''  comments\ -\ *.ytcs2.json  2> /dev/null; then
  _debug  " * Found a youtube-comment-downloader JSON file"
  for filename in comments\ -\ *.ytcs2.json; do
    source_video_id=$( \replace-cut.sh  ' '  3  "$filename" )
    # Only process the first file found:
    break
  done
fi

_debug  "$source_video_id"

if [ -z "$source_video_id" ]; then
  \echo  " * No source determined/specified."
  return  1
fi

comment_filename="comments - $( \date  --utc  +%Y-%m-%d\ %H։%M )"
_debug  ' * Downloading comments from..'
_debug  "   id:    \"$source_video_id\""
_debug  "   into:  \"$comment_filename\""



:<<'}'   #  youtube-comment-scraper
# https://github.com/philbot9/youtube-comment-scraper-cli/
# https://blog.spiralofhope.com/?p=45279
{
  comment_filename="$comment_filename".ytcs1.csv

  \youtube-comment-scraper  \
    --format csv  \
    --stream  \
    --  \
    "$source_video_id"  >  \
    "$comment_filename"
# |  \tee "$comment_filename"
}
:<<'}'   #  youtube-comment-scraper's other method
{
  comment_filename="$comment_filename".ytcs1.csv

  \youtube-comment-scraper  \
    --format csv  \
    --outputFile "$comment_filename"   \
    --  \
    "$source_video_id"
}



#:<<'}'   #  youtube-comment-downloader
# https://github.com/egbertbouman/youtube-comment-downloader
{
  comment_filename="$comment_filename".ytcs2.json
  # Requires Python 2.7+
  # python 3.x :
  # \sudo  \apt  install  python3-lxml  python3-cssselect
  # python 2.x :
  # \sudo  \apt  -y  install  python-cssselect  python-lxml  python-requests
  # Note:  You may have to `dos2unix downloader.py`
  \python2  /live/OS/Linux/bin/youtube-comment-downloader/youtube_comment_downloader/downloader.py  \
    --youtubeid="$source_video_id"  \
    --output="$comment_filename"
  if [ ! -s "$comment_filename" ]; then
    #  The comments file is empty
    if [ "$DEBUG" = 'true' ]; then
      \echo  'No comments fetched.'
    fi
    \rm  --force  --verbose  "$comment_filename"
  else
    #
    # Requires 7zip
    # TODO - Is it possible to just stream the text file into an archive and not have this separate step?
    if  \
      _=$( \which 7z )
    then
      #  The comments file has content
      if [ "$DEBUG" = 'true' ];
      then  \7z  a  -mx=9  "$comment_filename".7z  "$comment_filename"
      else  \7z  a  -mx=9  "$comment_filename".7z  "$comment_filename"   > /dev/null  2> /dev/null
      fi
      if $! ; then \rm  --force  --verbose  "$comment_filename" ; fi
    fi
  fi
}
