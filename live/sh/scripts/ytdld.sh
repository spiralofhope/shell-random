#!/usr/bin/env  sh

# Re-download the v.description file
# This is to recover from an issue with the description file not being properly downloaded when --write-description was being used in the main block of commands.

# Note that, although rare, you might get an error when downloading comments; check your scrollback buffer and re-try as needed.
# for i in *; do \cd "$i"; \echo "$PWD" ; ytdld.sh; cd - > /dev/null; done


if [ $# -eq 0 ]; then
  if  \stat  --printf=''  'v.info.json'  2> /dev/null; then
    source_video_id="$( \search-json.sh  'id'  'v.info.json' )"
  else
    exit  1
  fi
else
  source_video_id=" $@"
fi

# For some stupid reason the description file won't be properly downloaded if placed in the above statement.
\youtube-dl  \
  --skip-download  \
  --write-description  \
  --output 'v.%(ext)s'  \
  " $source_video_id"

\mv  'v.description'  'v.description.txt'
