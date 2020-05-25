#!/usr/bin/env  sh
# Scrape comments from YouTube videos
# For the commandline executable of youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# https://blog.spiralofhope.com/?p=45279
#
# See  `youtube-comment-scraper.sh`  for a web-GUI version.


if   [ -z "$1" ]; then
  \echo  " * Determining a source from this directory."
  # Example filename:
  # 'comments - 12345678901 - 2020-05-24 12։34.csv'
  for filename in comments*; do
    source_video_id=$( \echo  "$filename" | \cut  --delimiter=' '  --fields=3 )
    break
  done
else
  source_video_id="$( \echo  "$1"  |  \sed  's/.*v=//' )"
fi


if [ -z "$source_video_id" ]; then
  \echo  " * No source determined/specified."
  return  1
fi


comment_filename="comments - $source_video_id - $( \date  --utc  +%Y-%m-%d\ %H։%M ).csv"
\echo  " * Downloading comments from id:  $source_video_id"
\echo  "   $comment_filename"
\youtube-comment-scraper  \
  --format csv  \
  --outputFile "$comment_filename"   \
  --  \
  "$source_video_id"
