#!/usr/bin/env  sh



:<<'}'  # Testing
{
  \touch  \
    '.DS_Store'  \
    '.BridgeCache'  \
    '.BridgeCacheT'  \
    'Thumbs.db'  \
    'desktop.ini'  \
  ` # `
}


#:<<'}'  #  Run `find` once.
{
#dry_run='-dry-run'
\find  \
  ./  \
               -type f  -name '.DS_Store'  \
  -delete  -o  -type f  -name '.BridgeCache' \
  -delete  -o  -type f  -name '.BridgeCacheT' \
  -delete  -o  -type f  -name 'Thumbs.db'  \
  -delete  -o  -type f  -name 'desktop.ini' ` # Windows `  \
  -delete  \
  $dry_run \
` # `
}

#ls -a1 --color=always



:<<'}'  #  Run `find` multiple times.
{
  \find  -type f  -name '.DS_Store'     -delete
  \find  -type f  -name '.BridgeCache'  -delete
  \find  -type f  -name '.BridgeCacheT' -delete
  \find  -type f  -name 'Thumbs.db'     -delete
  # Windows
  \find  -type f  -name 'desktop.ini'   -delete
}


:<<'}'  #  Run `find` once.
{
\find  \
  ./  \
  -type f  \
  -regex  '.*\/\(\.DS_Store\|\.BridgeCache\|\.BridgeCacheT\|Thumbs\.db\|desktop\.ini\)'  \
` # `
}




# I want to use something like this:
variable='
  .DS_Store
  .BridgeCache
  .BridgeCacheT
  Thumbs.db
  desktop.ini
'
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
