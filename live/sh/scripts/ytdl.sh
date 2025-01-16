#!/usr/bin/env  sh


youtube_username='spiralofhope'


# https://github.com/\yt-dlp/\yt-dlp
# https://github.com/\yt-dlp/\yt-dlp#output-template-examples

# Note that --write-info-json might still contain personal information if special settings are used.



:<<'}'
{
SponsorBlock Options are interesting.
https://sponsor.ajay.app/

  --config-locations PATH

  --batch-file FILE

  --output '%(uploader)s/%(upload_date)s - %(title)s/v.%(ext)s'
  --split-chapters
    --force-keyframes-at-cuts


Cookies:
DEBUG='true'
# https://blog.spiralofhope.com/?p=79681#using-cookies
#USE_COOKIES='forced'
#USE_COOKIES='automatic'
COOKIES_FILE="$HOME/cookies.txt"
PROFILE_DIRECTORY="/mnt/c/Users/user/AppData/Local/BraveSoftware/Brave-Browser/User Data/Profile\ 1/Network/Cookies"


COOKIES_DIRECTORY=${COOKIES_DIRECTORY='brave:profile'}
# Defaults
USE_COOKIES=${USE_COOKIES='false'}
COOKIES_FILE=${COOKIES_FILE="$HOME/cookies.txt"}
DEBUG=${DEBUG='false'}

--cookies-from-browser brave:"$PROFILE_DIRECTORY"  \
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
    --skip-download  \
    --write-comments  \
    --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/comments--'"$( \date  --utc  +%Y-%m-%d_%H։%M )"'.%(ext)s'  \
  $*  ||  exit  1
}



_get_subtitles() {
# This doesn't work any more.  Too many downloads occur and it kills the connection.
# ERROR: Unable to download video subtitles for 'xx': HTTP Error 429: Too Many Requests
#   https://github.com/blackjack4494/yt-dlc/issues/158
# This doesn't work:
#      --sleep-subtitles 4  ` # Most videos are autotranslated into dozens of languages.`  \
#    --username  "$youtube_username"  ` # For some people, this will bypass the 429 error.  It prompts for a password.`  \
#
#
  \yt-dlp  \
    --no-abort-on-error  \
    --output  '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/subs/v.%(ext)s'  \
    --skip-download  \
    --write-subs  \
      --convert-subs  srt  \
      --sub-format  srt/best  \
      --sub-langs  all  \
      --write-auto-subs  \
  $*  ||  exit  1
}



_get_video_etc(){
  \yt-dlp  \
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
  $*  ||  exit  1
}



_update  &&  \
_get_video_etc  $*  &&  \
_get_comments   $*  &&  \
_get_subtitles  $*  &&  \
` # `



:<<'}'
{
#  --limit-rate 50K  \


For some reason this writes the json file one directory up:
  --trim-filenames 50  \
}
