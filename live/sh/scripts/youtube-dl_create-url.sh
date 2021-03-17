#!/usr/bin/env  sh

# Create a Windows-compatible .lnk (web page link) 



filename='v.url'


if [ $# -eq 0 ]; then
  \echo  " * Searching for the URL using 'v.info.json'..."
  url=$( search-json.sh  'webpage_url'  v.info.json )
else
  url="$1"
fi
\echo  "   Using the URL $1"
\echo  '[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IDList='               >   "$filename"
\echo    "URL=${url}"  >>  "$filename"
