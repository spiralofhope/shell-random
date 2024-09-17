#!/usr/bin/env  sh
# shellcheck  disable=1001
#   (I like backslashes)



:<<'}'   #  Usage
{
 Can double-quote to quote a single-quote:
   "example ' text"
 Can backslash to escape:
   example \' text
}



findin_files() {
  maxdepth="$1"
#maxdepth=999
  color="$2"
#color=always
  shift; shift  #  $3*
  
  \find  .  \
    -maxdepth "$maxdepth"  \
    -name '.git' -prune  -o  \
    -type f  \
    -print0  |  \
      \xargs  \
      --no-run-if-empty  \
      --null  \
        \grep  \
          --colour="$color"  \
          --fixed-strings  \
          --ignore-case  \
          --regexp="$*"
}



findin_files  "$@"



#findinall()           { findin_files.sh  999   always  "$*" ;}
#findinall_color_off() { findin_files.sh  999   never   "$*" ;}
#findhere()            { findin_files.sh    1   always  "$*" ;}
#findhere_color_off()  { findin_files.sh    1   never   "$*" ;}
