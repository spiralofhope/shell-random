#!/usr/bin/env  sh



# Change directory into a file's location.
# I'd love to hijack 'cd', but that doesn't work.
cdd() {
  if   [ ! -e $1 ]; then
    \echo  'cdd: no such file or directory:'  $*
  elif [ -L $1 ]; then
    \cd  $( \dirname  $( \realpath "$1" ) )
  else   # whatever else it happens to be.. just do whatever.
    \cd  "$*"
  fi
}



# FIXME: I don't understand why I cannot call this ls()
dir() {
  \ls \
    -1 \
    --almost-all \
    --color=always \
    --group-directories-first \
    --no-group \
    --quoting-style=shell \
    --size \
    "$@"  |\
      \less \
        --raw-control-chars \
        --no-init \
        --QUIT-AT-EOF \
        --quit-on-intr \
        --quiet
    ` # `
}


#  Make and change into a directory:
mcd() {
  directory="$1"
  if   [ -z $1 ]; then
    directory="$( \date  +%Y-%m-%d )"
  elif [ -f $1 ]; then   #  File
    directory="$( \dirname  "$1" )"
  fi
  # Silent errors:
  \mkdir  --parents "$directory"
  \cd               "$directory"
}


#  This used to have  --exclude-type supermount
#alias  df='\df  --human-readable'
_df_sorted(){
  _df() {
    \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
  }
  # The text at the top
  _df |\
    \head --lines=1
  # The actual list of stuff
  _df |\
    \tail --lines=+2  |\
    \sort --key=${1}
}


