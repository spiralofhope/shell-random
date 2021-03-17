#!/usr/bin/env  sh

# Create a Windows-compatible .lnk (web page link) 



filename='v.url'


\echo  'Creating a a Windows-compatible .lnk (web page link)...'
if [ $# -eq 0 ]; then
  \echo  ' * Searching for the URL using:  v.info.json'
  \echo  '   (this will take a moment)'
  url=$( search-json.sh  'webpage_url'  v.info.json )
else
  url="$1"
fi
\echo  "   Using the URL:  $url"
\echo  '[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IDList='               >   "$filename"
\echo    "URL=${url}"  >>  "$filename"
