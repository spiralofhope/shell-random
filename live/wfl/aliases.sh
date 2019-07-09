#!/usr/bin/env  sh



wfl_mount_drive() {
  if  ! [ -d /mnt/$1 ]; then
    \sudo  \mkdir  --parents  /mnt/$1
  fi
    \mount | \grep $1
    if [ $? == 1 ]; then
      \sudo  \mount  -t drvfs  $1:  /mnt/$1
    fi
  \cd  /mnt/$1
}
alias  a:='nocorrect  wfl_mount_drive  a  '
alias  A:='nocorrect                   a: '
alias  b:='nocorrect  wfl_mount_drive  b  '
alias  B:='nocorrect                   b: '
alias  c:='nocorrect  wfl_mount_drive  c  '
alias  C:='nocorrect                   c: '
alias  d:='nocorrect  wfl_mount_drive  d  '
alias  D:='nocorrect                   d: '
alias  e:='nocorrect  wfl_mount_drive  e  '
alias  E:='nocorrect                   e: '
alias  f:='nocorrect  wfl_mount_drive  f  '
alias  F:='nocorrect                   f: '
#
# These are generally not used, but are here just in case:
alias  w:='nocorrect  wfl_mount_drive  w  '
alias  w:='nocorrect                   w: '
alias  x:='nocorrect  wfl_mount_drive  x  '
alias  x:='nocorrect                   x: '
alias  y:='nocorrect  wfl_mount_drive  y  '
alias  y:='nocorrect                   y: '
alias  z:='nocorrect  wfl_mount_drive  z  '
alias  z:='nocorrect                   z: '



# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'
\alias  current="\cd  /$l/OS/"

# World of Warcraft
alias  addons="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/_dotfiles/Interface/AddOns/"
alias     wow="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/"


screen() {
  if ! [ -d /run/screen ]; then
    \sudo  \mkdir      /run/screen
    \sudo  \chmod 777  /run/screen
  fi
  /usr/bin/screen  $@
}
