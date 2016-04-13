#!/usr/bin/env  sh



findfile() {
  if [[ -d $1 ]]; then
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  file     $*
  else
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  file  .  $*
  fi
}


finddir() {
  if [[ -d $1 ]]; then
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  directory     $*
  else
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  directory  .  $*
  fi
}


findinall() {
  if [[ -d $1 ]]; then
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  file_contents  .  $*
  else
    /c/l/live/shell-random/git/live/sh/scripts/findhelper.sh  file_contents     $*
  fi
}