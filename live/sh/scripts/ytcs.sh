#!/usr/bin/env  sh
# Scrape comments from YouTube videos
# For the commandline executable of youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# https://blog.spiralofhope.com/?p=45279
#
# See  `youtube-comment-scraper.sh`  for a web-GUI version.


# TODO - make it smart and grab the latest copy of the comments of something I have in the current directory.


if [ -n "$1" ]; then
  source_video_id="$1"
  \echo  " * Downloading comments..."
  source_video_id="$( \echo  "$1"  |  \sed  's/.*v=//' )"
  comment_filename="comments - $source_video_id - $( \date  --utc  +%Y-%m-%d\ %H։%M ).csv"
  \youtube-comment-scraper  \
    --format csv  \
    --outputFile "$comment_filename"   \
    --  \
    "$source_video_id"
else
  \youtube-comment-scraper  "$@"
fi
