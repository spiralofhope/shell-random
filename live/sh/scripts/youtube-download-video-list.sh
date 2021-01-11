#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
  # I like my backslashes.

# Download a list of a channel's videos.
# This is useful for crawling through the entirety of a channel's videos.
# This writes to a file because it allows for easy re-use.

# TODO - Implement a switch for fetching the last x of videos, with --dateafter DATE
#        Allow switches to be passed, and test the above.
# TODO - Test on playlists.
# TODO - Just print the list
# TODO - If no parameter is given, then do a |tee



DEBUG='true'


# FIXME
:<<'}'   #  For `autotest.sh`:
{
  # TODO
  #https://www.youtube.com/c/jawed/videos
}



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}



_usage() {
  error_number="$1"
  \echo  ''
  \echo  " * ERROR - Give one of:"
  \echo  '   - no parameters, and an existing ./v.info.json'
  \echo  '   - no parameters, and a subdirectory with a ./v.info.json'
  \echo  '   - a json filename'
  \echo  '   - a channel URL'
  \echo  '     e.g.  https://www.youtube.com/c/jawed/videos'
  \echo  ''
  \echo  "   error code:  _usage  '$error_number'"
  \echo  ''
}



check_URL() {
  URL="$1"
  _debug  "checking  $URL"
  # Check that the URL is valid:
  HTTP_status_code="$( 
    string-split-and-output-all-after.sh  ' '  "$(
      \curl  --head  --silent  "$URL"  \
      |  \head  --lines=1  \
    )"
  )"
  _debug  "HTTP status code:  $HTTP_status_code"
  HTTP_status_code="$( string-remove-whitespace-trailing.sh "$HTTP_status_code" )"
  # shellcheck  disable=2091
    # I intend to execute is-string-a-number？.sh
  if    !  $( is-string-a-number？.sh  "$HTTP_status_code" ) ; then _usage  '3'  ; return 1
  elif     [ "$HTTP_status_code" -ne 200 ]                   ; then _usage  '4'  ; return 1
  fi
}


_download_URL() {
  URL="$1"
  #
  \youtube-dl  \
    --flat-playlist  \
    --get-id  \
    --no-call-home  \
    "$URL"  \
    |  \tee  "$filename"
}



if [ $# -eq 0 ]; then
  if  [ -f 'v.info.json' ]; then
    filename_referenced='v.info.json'
  else
    for i in *; do
      if ! [ -d "$i" ]            ; then continue; fi
      if ! [ -e "$i"/v.info.json ]; then continue; fi
      filename_referenced="${i}/v.info.json"
      break
    done
  fi
  if [ "$filename_referenced" = '' ]; then
    _usage  '1'
    return  1
  fi
elif [ $# -gt 1 ]; then
  _usage  '2'
  return  1
elif [ -f "$1" ]; then
  filename_referenced="$1"
else
  # A non-file; assuming it's a URL.
  URL="$1"
  if  !  \
    check_URL  "$URL"
  then
    return  1
  fi
  # remove /videos
  # FIXME - determine if /videos is even there..
  channel_name="$( string-remove-n-characters-trailing.sh  7   "$URL" )"
  _debug  "channel_name:  $channel_name"
  channel_name="$( string-split-and-output-all-after.sh  '/'  "$channel_name" )"
  _debug  "channel_name:  $channel_name"
  channel_name="$( string-fetch-last-word.sh  "$channel_name")"
  _debug  "channel_name:  $channel_name"
  date_hours_minutes=$( \date.sh  'minutes' )
  filename="videos-list--${channel_name}--${date_hours_minutes}".txt
  _debug  "filename:  $filename"
  \echo  ' * Downloading the list..'
  _download_URL  "$URL"
  return  $?
fi



# If the variable is set
channel_name="$( \search-json.sh  'uploader'     "$filename_referenced" )"
channel_id="$(   \search-json.sh  'channel_id'   "$filename_referenced" )"
\echo  ' * Downloading video IDs for:'
\echo  "   channel_name:  ${channel_name}"
\echo  "   channel_id:    ${channel_id}"
#
string_length_maximum=29
string_to_append='…'
string="$channel_name"
channel_name=$( string-truncate-and-append.sh  "$string_length_maximum"  "$string_to_append"  "$string" )
#date_hours_minutes_seconds=$( \date.sh  'seconds' )
#filename="${channel_name}__${channel_id}__${date_hours_minutes_seconds}".txt
date_hours_minutes=$( \date.sh  'minutes' )
filename="videos-list--${channel_name}--${date_hours_minutes}".txt
_debug  "filename:  $filename"
# e.g.:  jawed
#   or:  UC4QobU6STFB0P71PMvOGN5A
if    check_URL      "https://www.youtube.com/channel/$channel_id/videos"
then  _download_URL  "https://www.youtube.com/channel/$channel_id/videos";  return  $?
elif  check_URL      "https://www.youtube.com/c/$channel_id/videos"
then  _download_URL  "https://www.youtube.com/c/$channel_id/videos"      ;  return  $?
elif  check_URL      "https://www.youtube.com/c/$channel_name/videos"
then  _download_URL  "https://www.youtube.com/c/$channel_name/videos"    ;  return  $?
else
  \echo  ' * Fetching channel_url, this may take a while...'
  channel_url="$(  \search-json.sh  'channel_url'  "$filename_referenced" )"
  if    check_URL  "$channel_url/videos"
  then  _download_URL  "$channel_url/videos" ; return  $?
  fi
fi



\echo  ' * ERROR:  Something is amok; nothing could be downloaded'
return  1
