#!/usr/bin/env  sh

# Create a Windows-compatible .lnk (web page link) 



filename='v.url'

if [ ! -z "$#" ]; then
  url="$1"
else
  url=$( search-json.sh  'webpage_url'  v.info.json )
fi
\echo  '[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IDList='               >   "$filename"
\echo  "URL=${url}"  >>  "$filename"
