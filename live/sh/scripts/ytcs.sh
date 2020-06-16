#!/usr/bin/env  sh
# Scrape comments from YouTube videos
# For the commandline executable of youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# https://blog.spiralofhope.com/?p=45279
#
# See  `youtube-comment-scraper.sh`  for a web-GUI version.


if   [ "$#" -ne 0 ]; then
  source_video_id="$( \echo  "$1"  |  \sed  's/.*v=//' )"
elif  \stat  --printf=''  'v.info.json'  2>/dev/null; then
  # See also `read-JSON.sh`
  \echo  " * Found a JSON file"
  #:<<'  }'   #  Check for a JSON file
  search_JSON() {
    key_search="$1"
    input_filename="$2"

    # I don't know if there is a better way to write this:
    # shellcheck disable=2002
    \cat  "$input_filename"  |\
      \tr -d '{}"'  |\
      \tr , \\n  |\
      while  \read  -r  line; do
        # Skip over lines starting with '//' (comments):
        #   Note that comments are not officially supported by the JSON format, although individual libraries may support them.  As such, commented-JSON files ought to be run through a preparser like JSMin before actually being used.
        [ "${line##//*}" ]  ||  continue
        key=$(   \echo "$line" | \cut  -d':' -f1 )
        value=$( \echo "$line" | \cut  -d':' -f2 )
        #\echo  "$line"
        #\echo  "$key"
        #\echo  "$value"
        if [ "$key" = "$key_search" ]; then
          # Strip leading whitespace:
          value=${value#${value%%[![:space:]]*}}
          printf  '%s\n'  "$value"
          # Stop at the first match:
          return
        fi
      done  \
    ###
  }
  source_video_id="$( search_JSON  'id'  'v.info.json' )"
elif  \stat  --printf=''  comments\ -\ *.csv  2>/dev/null; then
  \echo  " * Found a CSV file"
  # Example filename:
  #   'comments - 12345678901 - 2020-05-24 12։34.csv'
  # Example id:
  #   12345678901
  for filename in comments\ -\ *.csv; do
    source_video_id=$( \echo  "$filename" | \cut  --delimiter=' '  --fields=3 )
    # Only process the first file found:
    break
  done
fi


if [ -z "$source_video_id" ]; then
  \echo  " * No source determined/specified."
  return  1
fi

comment_filename="comments - $source_video_id - $( \date  --utc  +%Y-%m-%d\ %H։%M ).csv"
\echo  " * Downloading comments from.."
\echo  "   id:    \"$source_video_id\""
\echo  "   into:  \"$comment_filename\""


#:<<'}'
{
\youtube-comment-scraper  \
  --format csv  \
  --stream  \
  --  \
  "$source_video_id"  >  \
  "$comment_filename"
}

# | tee output.json


:<<'}'
{
\youtube-comment-scraper  \
  --format csv  \
  --outputFile "$comment_filename"   \
  --  \
  "$source_video_id"
}

