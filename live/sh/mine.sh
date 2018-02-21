#!/usr/bin/env  sh



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


findfile() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  file      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  file  ./  $*
  fi
}


finddir() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  directory      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  directory  ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findinall() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  999            $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  999        ./  $*
  fi
}


# TODO - Technically I could make a `findin` that applies to only one file, but I won't bother.
findhere() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  1              $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  1          ./  $*
  fi
}


# Make and change into a directory:
mcd() {
  \mkdir  "$1" &&\
  \cd  "$1"
}


# This used to have  --exclude-type supermount
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
alias  df='_df_sorted 5'    # sorted by mountpoint
alias  df='_df_sorted 1'    # sorted by filesystem
