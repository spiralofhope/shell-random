#!/usr/bin/env  sh



:<<'}'  # Testing
{
  # FIXME - replace with an shism
  \touch  \
    '.DS_Store'  \
    '.BridgeCache'  \
    '.BridgeCacheT'  \
    'Thumbs.db'  \
    'desktop.ini'  \
  ` # `
}


#:<<'}'  #  
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

#ls -a1 --color=always


:<<'}'  #  Via a regex
{
  \find  \
    ./  \
    -type f  \
    -regex  '.*\/\(\.DS_Store\|\.BridgeCache\|\.BridgeCacheT\|Thumbs\.db\|desktop\.ini\)'  \
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



# I don't understand why this doesn't work..
:<<'}'  #  Run `find` once.
#  Split by lines, ignore beginning spaces, accept empty lines, accept inner spaces.
{
  echo '----'
  echo "$variable" |\
  while read line; do
    #echo "$line"
    __=$__$line
    __=foo
  done
  echo '----'

  echo $__
}
