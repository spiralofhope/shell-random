#!/usr/bin/env  sh



alias  c:='nocorrect  \cd  /mnt/c'
alias  C:=c:
#alias  d:='nocorrect  \cd  /mnt/d'
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
alias  a:='wfl_mount_drive  d'
alias  A:a:
alias  b:='wfl_mount_drive  d'
alias  B:b:
alias  e:='wfl_mount_drive  e'
alias  E:e:
alias  f:='wfl_mount_drive  f'
alias  F:f:


local  l='/mnt/c/live'

alias  l="nocorrect  \cd  $l"

# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'
\alias  current="\cd  /$l/OS/"

# World of Warcraft
alias  addons="nocorrect  \cd  /$l/games/World_of_Warcraft/_dotfiles/Interface/AddOns/"
alias     wow="nocorrect  \cd  /$l/games/World_of_Warcraft/"


screen() {
  if ! [ -d /run/screen ]; then
    \sudo  \mkdir      /run/screen
    \sudo  \chmod 777  /run/screen
  fi
  /usr/bin/screen  $@
}
