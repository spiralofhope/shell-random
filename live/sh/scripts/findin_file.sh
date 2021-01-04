#!/usr/bin/env  sh
# shellcheck  disable=1001
#   (I like backslashes)



# TODO?  Make others which don't use --line-number



findin_file() {
  color="$1"
  file="$2"
  shift; shift   #  $3*
  \grep  \
    --colour="$color"  \
    --fixed-strings  \
    --ignore-case  \
    --line-number  \
    "$*"  \
    --  \
    "$file"
}



findin_file  "$@"



#findin()           { findin_file.sh  'always'  "$@" ;}
#findin_color_off() { findin_file.sh  'never'   "$@" ;}
