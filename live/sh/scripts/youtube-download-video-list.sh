#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
  # I like my backslashes.

# Download a list of a channel's videos.
# This is useful for crawling through the entirety of a channel's videos.
# This writes to a file because it allows for easy re-use.

# TODO - Implement a switch for fetching the last x of videos, with --dateafter DATE
#        Allow switches to be passed, and test the above.
# TODO - Test on playlists.



# FIXME
:<<'}'   #  For `autotest.sh`:
{
  # TODO
}



if [ $# -eq 0 ]; then
  if  [ -f 'v.info.json' ]; then
    filename_referenced='v.info.json'
  else
    \echo  "ERROR - Give one of:"
    \echo  ' - a json filename'
    \echo  ' - a channel URL'
    \echo  1
  fi
elif [ -f "$1" ]; then
  filename_referenced="$1"
else
  \echo  'not implemented yet..'
  return  1
  # Assume I've been passed a URL.
  # TODO - Check that the URL is valid.
  #        Maybe ping it?
  #channel_url="$1"
  # FIXME - get $channel_id
  # FIXME - get $channel_name
fi


# This isn't right..
#if [ ${#filename_referenced} -eq 0 ]; then
  # I've been passed a URL



channel_id="$(   \search-json.sh  'channel_id'   "$filename_referenced" )"
channel_name="$( \search-json.sh  'uploader'     "$filename_referenced" )"



\echo  ' * Downloading video IDs for:'
\echo  "   uploader:     ${channel_name}"
\echo  "   channel_id:   ${channel_id}"
string_length_maximum=29
string_to_append='…'
string="$channel_name"
channel_name=$( string-truncate-and-append.sh  "$string_length_maximum"  "$string_to_append"  "$string" )
#date_hours_minutes_seconds=$( \date.sh  'seconds' )
#filename="${channel_name}__${channel_id}__${date_hours_minutes_seconds}".txt
date_hours_minutes=$( \date.sh  'minutes' )
filename="videos-list--${date_hours_minutes}".txt



_go() {
  channel_url="$1"
  #
  \echo  ' * Attempting the URL:'
  \echo  "   $channel_url"
  #
  # --user-agent might bypass some instances of the error "Unable to extract video data"
  # I use `tee` because it is nice to have feedback.
  \youtube-dl  "$channel_url"  \
    --get-id  \
    --ignore-errors  \
    2>&1  |\
    \tee  "$filename"
}



_go  "http://youtube.com/channel/$channel_id"
if [ -z "$filename" ]; then
  _go  "http://youtube.com/c/$channel_id"
fi
if [ -z "$filename" ]; then
  \echo  ' * Fetching channel_url, this may take a while...'
  channel_url="$(  \search-json.sh  'channel_url'  "$filename_referenced" )"
  \echo  ' * TODO - implement this style of URL'
  _go  "$channel_url"
fi



if [ -z "$filename" ]; then
  \echo  ' * All efforts have completely failed.  Is that URL valid?'
  \rm  --force  "$filename"
  return  1
fi



# youtube-dl will occasionally give an error:
# ERROR: jNQXAC9IVRw: YouTube said: Unable to extract video data
# Maybe such videos require a login or have some other issue, but such details are responsibility of whomever uses the list.
# TODO - There may be a way to output errors into their own file..

# Cleaned-up:
\cut       --delimiter=':' --fields=2  \
  |  \cut  --delimiter=' ' --fields=2  \
  "$filename"  \
  >  "$filename".errors-removed.txt


# Only errors:
\fgrep  --invert-match  \
  --file="$filename"  \
  "$filename".errors-removed.txt  \
  >  "$filename".errors-only.txt


# If file is zero size, then no errors were found; delete associated files.
if [ ! -s "$filename".errors-only.txt ]; then
  \rm  --force  "$filename".errors-removed.txt
  \rm  --force  "$filename".errors-only.txt
fi
