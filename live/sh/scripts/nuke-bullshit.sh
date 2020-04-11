#!/usr/bin/env  sh
# Delete a list of files

# TODO - Build the list as an array.
# TODO - Build the list as a text file.



#:<<'}'  #  Create a list of files
{
  
  for file in \
    .DS_Store  \
    .BridgeCache  \
    .BridgeCacheT  \
    Thumbs.db  \
    desktop.ini  \
  ; do
    :>  "$file"
  done
  \echo  '--'
  \ls  -A1
  \echo  '--'
}


#:<<'}'   #   Delete using `find`, using multiple options
{
  \find  \
    ./  \
        -type f  -name '.DS_Store'      -delete  \
    -o  -type f  -name '.BridgeCache'   -delete  \
    -o  -type f  -name '.BridgeCacheT'  -delete  \
    -o  -type f  -name 'Thumbs.db'      -delete  \
    ` # Windows `  \
    -o  -type f  -name 'desktop.ini'    -delete  \
     \
  ` # `
}



#:<<'}'   #   Delete using `find`, using a single long regex
{
  \find  \
    ./  \
    -type f  \
    -regextype  posix  \
    -regex  '.*\/\(\.DS_Store\|\.BridgeCache\|\.BridgeCacheT\|Thumbs\.db\|desktop\.ini\)'  \
    -delete  \
  ` # `
}





:<<'}'   #  TODO - use an array
{
  variable='
    .DS_Store
    .BridgeCache
    .BridgeCacheT
    Thumbs.db
    desktop.ini
  '
}
# Idea:  Use items in a plain text file.



 #I don't understand why this doesn't work..
:<<'}'   #  Run `find` once.
          #  Split by lines, ignore beginning spaces, accept empty lines, accept inner spaces.
{
  \echo  '----'
  \echo  "$variable"  |\
    while  \read  -r  line; do
      #echo "$line"
      __=$__$line
      __=foo
    done
  \echo  '----'

  \echo  $__
}



\ls  -A1
