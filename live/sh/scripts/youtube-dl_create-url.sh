#!/usr/bin/env  sh



#:<<'}'   #  Create a Windows-compatible .lnk (web page link) to the source
{
filename='v.url'
url=$( search-json.sh  'webpage_url'  v.info.json )
\echo  '[{000214A0-0000-0000-C000-000000000046}]
Prop3=19,2
[InternetShortcut]
IDList='               >   "$filename"
\echo  "URL=${url}"  >>  "$filename"
}
