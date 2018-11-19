#!/usr/bin/env  sh



fbpanel_restart(){
  \killall  fbpanel  &&  \fbpanel &
  #\sleep  2
  #\fbpanel &
  #\sleep  2
  \exit
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
  \mkdir  "$1" &&\
  \cd  "$1"
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


