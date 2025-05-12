#!/usr/bin/env  sh

# TODO - It would be interesting to put the video title or other info as the terminal title:
# \print  -Pn  "\e]0;%~ - $1\a"


# Cookies
# If set, use cookies
# TODO - --write-info-json might still contain personal information if cookies are used.
#   I checked, it doesn't contain my username.
# A space is not valid in this filename.  Trust me, that can't be implemented as far as I can tell.
cookies_file="$HOME/youtube-cookies-netscape.txt"
cookies_file=''
# If you are having problems, make sure you re-create your ~/youtube-cookies-netscape.txt
# F12 > Application > Cookies > youtube.com > copy it all to ~/youtube-cookies.txt
# rm -f ~/youtube-cookies-netscape.txt ; python ~/python-convert-chrome-cookies-to-netscape-format/convert-cookies.py ~/youtube-cookies.txt > ~/youtube-cookies-netscape.txt



:<<'}'   #  Other notes
{
# Debugging is not implemented.
#DEBUG='true'
#DEBUG=${DEBUG='false'}


# https://github.com/\yt-dlp/\yt-dlp
# https://github.com/\yt-dlp/\yt-dlp#output-template-examples

# Note that --write-info-json might still contain personal information if special settings are used.
# As of 2025-03-29 - Logins (with --username ) is not supported for YouTube


SponsorBlock Options are interesting.
https://sponsor.ajay.app/

  --config-locations PATH

  --batch-file FILE

  --output '%(uploader)s/%(upload_date)s - %(title)s/v.%(ext)s'
  --split-chapters
    --force-keyframes-at-cuts
}



_update(){
  # For testing:
  #\touch  --date="yesterday"  "$0"
  date_script=$( \date -r "$0" +"%Y-%m-%d" )
  date_today=$(  \date         +"%Y-%m-%d" )
  #
  if [ "$date_script" != "$date_today" ]; then
    \yt-dlp  --update  ||  exit  1
    \touch  "$0"
  else
    \echo 'No update needed.'
  fi
}


_get_comments() {
  \yt-dlp  \
    $( [ -f "$cookies_file" ] && echo "--cookies $cookies_file" )  \
    --skip-download  \
    --write-comments  \
    --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/comments--'"$( \date  --utc  +%Y-%m-%d_%H։%M )"'.%(ext)s'  \
  "$@"  ||  exit  1
}



_get_subtitles() {
# This doesn't work any more.  Too many downloads occur and it kills the connection.
# ERROR: Unable to download video subtitles for 'xx': HTTP Error 429: Too Many Requests
#   https://github.com/blackjack4494/yt-dlc/issues/158
# This doesn't work:
#      --sleep-subtitles 4  \
#    --username  "$youtube_username"  ` # For some people, this will bypass the 429 error.  It prompts for a password.`  \
#    --no-abort-on-error  --  seems to not be valid.
#
# TODO, maybe if I get the list?  Then:
# - Check the disk and skip those already known
# - Adjust --sub-langs all,-live_chat


  # TODO - build a list using --list-subs and then walk through them one at a time, checking the download directory and making a manual timeout to ensure that I keep trying.

  # List them:
  \yt-dlp  \
    $( [ -f "$cookies_file" ] && echo "--cookies $cookies_file" )  \
    --ignore-errors  \
    --skip-download  \
      --list-subs  \
  "$@"  ||  exit  1

  # Ensure I can get the essential subtitles:
  \yt-dlp  \
    $( [ -f "$cookies_file" ] && echo "--cookies $cookies_file" )  \
    --ignore-errors  \
    --output  '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/subs/v.%(ext)s'  \
    --skip-download  \
    --write-subs  \
      --sub-langs  "en.*,.*-orig,live_chat"  \
      --convert-subs  srt  \
      --sub-format  srt/best  \
      --write-auto-subs  \
  "$@"  ||  exit  1

  # Attempt to get the remaining subtitles:
  \yt-dlp  \
    $( [ -f "$cookies_file" ] && echo "--cookies $cookies_file" )  \
    --ignore-errors  \
    --output  '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/subs/v.%(ext)s'  \
    --skip-download  \
    --sleep-subtitles 3  \
    --write-subs  \
      --sub-langs  "all,-en.*,-.*-orig,-live_chat"  \
      --convert-subs  srt  \
      --sub-format  srt/best  \
      --write-auto-subs  \
  "$@"  ||  exit  1
}



_get_video_etc(){

  :<<'  }'   #  Cookies
  {
  # https://blog.spiralofhope.com/?p=79681#using-cookies

  # Cookies will not work when the browser is open, because Windows sucks.
  PROFILE_DIRECTORY="/mnt/c/Users/user/AppData/Local/BraveSoftware/Brave-Browser/User Data/Profile 3"
  if [ ! -d "$PROFILE_DIRECTORY" ]; then
    \echo  '$PROFILE_DIRECTORY does not exist:'
    \echo  "\"$PROFILE_DIRECTORY\""
    exit 1
  fi
  --cookies-from-browser brave:"$PROFILE_DIRECTORY"  \
  #

    --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  \

  }


  # This is also good code 
  #$( [ -f "$cookies_file" ] && printf '%s\n' "--cookies $cookies_file" )  \

  \yt-dlp  \
    $( [ -f "$cookies_file" ] && echo "--cookies $cookies_file" )  \
    --concurrent-fragments  3  \
      --no-keep-fragments  \
    --continue  \
    --embed-chapters  \
    --embed-metadata  \
      --xattrs  \
    --no-abort-on-error  \
    --no-write-subs  \
      --sub-langs  en  \
      --embed-subs  \
      --write-auto-subs  \
    --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/v.%(ext)s'  \
    --rm-cache-dir  \
    --windows-filenames  \
    --write-description  \
    --write-info-json  \
      --clean-info-json  \
      --embed-info-json  \
    --write-link  \
      --write-desktop-link  \
      --write-url-link  \
      --write-webloc-link  \
    --write-thumbnail  \
      --embed-thumbnail  \
  "$@"  ||  exit  1
}




_update  &&  \
_get_video_etc  "$@"  &&  \
_get_comments   "$@"  &&  \
_get_subtitles  "$@"  &&  \
` # `




:<<'}'
{
#  --limit-rate 50K  \


For some reason this writes the json file one directory up:
  --trim-filenames 50  \
}
