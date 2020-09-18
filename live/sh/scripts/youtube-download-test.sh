#!/usr/bin/env  sh



# FIXME - I can't get this working.. my cookies file doesn't work, at least it doesn't work with the example age-restricted video I uploaded..




:<<'_ENDNOTES_'  #  On age restriction etc.
youtube-dl will give an error like:
  ERROR: jNQXAC9IVRw: YouTube said: Unable to extract video data
  WARNING: Unable to look up account info: HTTP Error 404: Not Found

The description might have, at its bottom:
  Notice
  Age-restricted video (based on Community Guidelines)

Age-restricted content
  https://support.google.com/youtube/answer/2802167


(1) I am unable to log in with either --username or ~/.netrc (and --netrc)

(2) --username and --password are currently bugged.
    See https://github.com/ytdl-org/youtube-dl/issues/26400

(3) One guy said to use an app password, but I don't think that's right.
      https://support.google.com/accounts/answer/185833

(4) SOLUTION - Using Cookies:
    https://apple.stackexchange.com/questions/349697/how-to-use-youtube-dl-cookies
    For chrome, try:
     https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg/related
     -  No reboot required
     -  Switch to a YouTube tab
     -  Click that extension's icon
     -  Notice the text "To download cookies for this tab click here, or download all cookies."
     -  Click "click here" and save that  `cookies.txt`  file to a known location.  This is currently hard-coded to  `~/cookies.txt`

_ENDNOTES_



DEBUG='true'
#USE_COOKIES='forced'
#USE_COOKIES='automatic'
COOKIES_FILE="$HOME/cookies.txt"



#:<<'}'   #  For `autotest.sh`
{
  if [ $# -eq 0 ]; then
    # Pass example parameters to this very script:

    # Testing on a valid video
    #"$0"  'jNQXAC9IVRw'

    # Testing with a login required...
    "$0"  '1jYdHa_bu2k'

    # Testing when a video has been removed..
    #"$0"  'ZErUCQyS9AQ'
    return
  fi

  # TODO - instructions
  #if   [ "$#" -ne 1 ]; then return  1; fi
}



# Defaults
USE_COOKIES=${USE_COOKIES='false'}
COOKIES_FILE=${COOKIES_FILE="$HOME/cookies.txt"}
DEBUG=${DEBUG='false'}

source_video_id="$1"
# TODO - sanity-check:  forced, automatic, false
#flag="$2"



_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$@"  >&2
  fi
}



_debug  "$0  $1  $2"



#case "$USE_COOKIES" in
  #'forced' )
    #:
  #;;
  #'automatic' )
    #:
  #;;
  #* )
    #:
    ## e.g. false
  #;;
#esac



:<<'}'   #  Testing if cookies are required..
{
  _debug  'Testing if cookies are required..'
  if  \
    #_=$(  \

    \youtube-dl  \
      --get-id  \
      --no-call-home  \
      "$source_video_id"  \
    #2> /dev/null )
  then
    _debug  'No cookies are required.'
    return  0
  fi
  _debug  '.. cookies might be required.'
}
#return



#:<<'}'   #  Testing if cookies will work..'
{
  if [ ! -e "$COOKIES_FILE" ]; then
    \echo  'ERROR:  The cookies file is required, but does not exist:'
    \echo  "$COOKIES_FILE"
    \echo  ''
    return  2
  fi
  #
  _debug  'Testing if cookies will work..'
  if
    #_=$(  \

    \youtube-dl  \
      --get-id  \
      --no-call-home  \
      --cookies  "$COOKIES_FILE"  \
      "$source_video_id"  \
    #2> /dev/null )
  then
    _debug  "Cookies are required, and work."
    return  1
  fi
}



\echo  'ERROR 1 - The cookies file is required, and exists, but does not work:'
\echo  "$COOKIES_FILE"
\echo  'Perhaps generate a new one?'
\echo  ''
\echo  'Or perhaps the video was removed.'
\echo  ''
return  3
