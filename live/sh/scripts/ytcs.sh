#!/usr/bin/env  sh

# Scrape comments from YouTube videos.
#
# Uses youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
#   https://blog.spiralofhope.com/?p=45279
#
# Requires my `search-JSON.sh`.

# TODO - I want to detect signals and abort the download without killing autotest.sh, but Python's KeyboardInterrupt is too aggressive or something..


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
elif  \stat  --printf=''  'v.info.json'  2> /dev/null; then
  _debug  " * Found a JSON file"
  source_video_id="$( \search-json.sh  'id'  'v.info.json' )"
elif  \stat  --printf=''  comments\ -\ *.csv  2> /dev/null; then
  # I prefer a CSV when using youtube-comment-scraper.
  _debug  " * Found a CSV file"
  for filename in comments\ -\ *.csv; do
    source_video_id=$( \replace-cut.sh  ' '  3  "$filename" )
    # Only process the first file found:
    break
  done
fi


if [ -z "$source_video_id" ]; then
  \echo  " * No source determined/specified."
  return  1
fi

comment_filename="comments - $source_video_id - $( \date  --utc  +%Y-%m-%d\ %H։%M )"
_debug  ' * Downloading comments from..'
_debug  "   id:    \"$source_video_id\""
_debug  "   into:  \"$comment_filename\""


:<<'}'   #  youtube-comment-scraper
# https://github.com/philbot9/youtube-comment-scraper-cli/
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

  \youtube-comment-downloader  \
    --youtubeid="$source_video_id"  \
    --output="$comment_filename"
}



# I'm left with a zero-size file if the download fails; delete it.
[ -s "$comment_filename" ]  ||  \rm  --force  "$comment_filename"
