#!/usr/bin/env  sh

# Create a Windows-compatible .lnk (web page link) 



filename='v.url'


\echo  'Creating a a Windows-compatible .lnk (web page link)...'
if [ $# -eq 0 ]; then
  json_filename='v.info.json'
  if [ ! -f "$json_filename" ]; then
    \echo  "ERROR:  $json_filename  not found"
    exit 1
  fi
  \echo  " * Searching for the URL using:  $json_filename"
  \echo  '   (this will take a moment)'
  url=$( search-json.sh  'webpage_url'  "$json_filename" )
else
  url="$1"
fi
\echo  "   Using the URL:  $url"
\echo  '[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IconIndex=0
HotKey=0
IconFile=%SystemRoot%\System32\SHELL32.dll
IDList='               >   "$filename"
\echo    "URL=${url}"  >>  "$filename"
