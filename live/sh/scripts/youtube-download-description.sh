#!/usr/bin/env  sh
# shellcheck  disable=1001
  # I like using backslashes.

# Download the v.description file
#   This is to recover from an issue with the description file not being properly downloaded when --write-description was being used in the main block of commands.
#
# You will get an error downloading the description of videos which require a login, like age restriction.  For more information on that, see  `youtube-download.sh`  .  You will need to generate a  `cookies.txt`  file to bypass this restriction.



# for i in *; do \cd "$i"; \echo "$PWD" ; youtube-download-description.sh; cd - > /dev/null; done



# Uncomment if you have provided this file and want youtube-dl to present those credentials, e.g. for age-restricted videos:
cookies="$HOME/cookies.txt"



cookies=${cookies=' '}
if [ ! "$cookies" = ' ' ]; then
  if [ ! -e "$cookies" ]; then
    \echo  'ERROR:  Cookies file does not exist:'
    \echo  "$cookies"
    exit  1
  else
    cookies="--cookies=$cookies"
  fi
fi



if [ $# -eq 0 ]; then
  if  \stat  --printf=''  'v.info.json'  2> /dev/null; then
    source_video_id="$( \search-json.sh  'id'  'v.info.json' )"
  else
    exit  1
  fi
else
  # shellcheck  disable=2124
  source_video_id=" $@"
fi



date_hours_minutes=$( \date.sh  'minutes' )
filename="v.description--${date_hours_minutes}".txt



\youtube-dl  \
  --get-description  \
  --no-call-home  \
  " $source_video_id" > "$filename"  \
  "$cookies"



# Delete empty/failed downloads.
if ! [ -s "$filename" ]; then
  \rm  --force  "$filename"
fi
