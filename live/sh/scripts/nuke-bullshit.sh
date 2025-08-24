#!/usr/bin/env  sh
# Delete a list of files

# TODO - Build the list as a HEREDOC.



# For testing purposes, create a list of files:
:<<'}'
{
  for file in      \
    .DS_Store      \
    .BridgeCache   \
    .BridgeCacheT  \
    desktop.ini    ` # Windows ` \
    photothumb.db  \
    Thumbs.db      \
  ; do
    :>  "$file"
  done
#  \echo  '--'
#  \ls  -A1
#  \echo  '--'
}


# Method 1
#:<<'}'   #   Delete using `find`, using multiple options
{
  \find  \
    ./  \
        -type f  -name '.DS_Store'      -delete  \
    -o  -type f  -name '.BridgeCache'   -delete  \
    -o  -type f  -name '.BridgeCacheT'  -delete  \
    -o  -type f  -name 'desktop.ini'    -delete  ` # Windows ` \
    -o  -type f  -name 'photothumb.db'  -delete  \
    -o  -type f  -name 'Thumbs.db'      -delete  \
     \
  ` # `
}



# Method 2
:<<'}'   #   Delete using `find`, using a single long regex
{
  \find  \
    ./  \
    -type f  \
    -regextype  posix-basic  \
    -regex  '.*\/\(\.DS_Store\|\.BridgeCache\|\.BridgeCacheT\|desktop\.ini\|photothumb\.db\|Thumbs\.db\)'  \
    -delete  \
  ` # `
}
