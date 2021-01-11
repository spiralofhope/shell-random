#!/usr/bin/env  sh
# shellcheck  disable=1001
  # I like using backslashes.

# Download the v.description file
#   This is to recover from an issue with the description file not being properly downloaded when --write-description was being used in the main block of commands.
#
# You will get an error downloading the description of videos which require a login, like age restriction.  For more information on that, see  `youtube-download.sh`  .  You will need to generate a  `cookies.txt`  file to bypass this restriction.



# for i in *; do \cd "$i"; \echo "$PWD" ; youtube-download-description.sh; cd - > /dev/null; done



# Uncomment if you have provided this file and want youtube-dl to present those credentials, e.g. for age-restricted videos:
#cookie_file="$HOME/netscape-cookies.txt"



cookie_file=${cookie_file=''}
if [ ! "$cookie_file" = '' ]  \
&& [ ! -e "$cookie_file" ]
then
  \echo  'cookie file not found'
  exit  1
fi



if [ $# -eq 0 ]; then
  if  \stat  --printf=''  'v.info.json'  2> /dev/null; then
    source_video_id="$( \search-json.sh  'id'  'v.info.json' )"
  else
    exit  1
  fi
else
  # shellcheck  disable=2124
  source_video_id="$@"
fi



date_hours_minutes=$( \date.sh  'minutes' )
filename="v.description--${date_hours_minutes}".txt



if [ "$cookie_file" = '' ]; then
  \youtube-dl  \
    --get-description  \
    --no-call-home  \
    --  \
    "$source_video_id"  \
    > "$filename"
else   #  use cookies
  \youtube-dl  \
    --cookies="$cookie_file"  \
    --get-description  \
    --no-call-home  \
    --  \
    "$source_video_id"  \
    > "$filename"
fi




# Delete empty/failed downloads.
if ! [ -s "$filename" ]; then
  \rm  --force  "$filename"
fi
