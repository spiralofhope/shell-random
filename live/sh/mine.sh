#!/usr/bin/env  sh



# NOTE - this will all get broken when ported over to zsh
# the easy fix would be to do symlinking for /c

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


# technically I could make a `findin` that applies to only one file, but I won't bother.


findinall() {
  if [[ -d $1 ]]; then
    ${shell_random}/live/sh/scripts/findhelper.sh  file_contents      $*
  else
    ${shell_random}/live/sh/scripts/findhelper.sh  file_contents  ./  $*
  fi
}