#!/usr/bin/env  sh



alias  c:='nocorrect  \cd  /mnt/c'
alias  C:=c:
alias  d:='nocorrect  \cd  /mnt/d'
alias  D:=d:
e:() {
  if  ! [ -d /mnt/e ]; then
    \sudo  \mkdir  --parents  /mnt/e
    \sudo  \mount  -t drvfs  E:  /mnt/e
  fi
  \cd  /mnt/e
}
alias  E:=e:


local  l='/mnt/c/live'

alias  l="nocorrect  \cd  $l"

# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'
\alias  current="\cd  /$l/OS/"

# World of Warcraft
alias  addons="nocorrect  \cd  /$l/games/World_of_Warcraft/_dotfiles/Interface/AddOns/"
alias     wow="nocorrect  \cd  /$l/games/World_of_Warcraft/"
