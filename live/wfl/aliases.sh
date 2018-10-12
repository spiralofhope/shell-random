#!/usr/bin/env  sh



alias c:='nocorrect  \cd  /mnt/c'
alias C:='nocorrect  \cd  /mnt/c'
alias d:='nocorrect  \cd  /mnt/d'
alias D:='nocorrect  \cd  /mnt/d'


local  l='/mnt/d/live'

alias  l="nocorrect  \cd  $l"

# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'
\alias  current="\cd  /$l/OS/"

# World of Warcraft
alias  addons="nocorrect  \cd  /$l/World_of_Warcraft/_dotfiles/Interface/AddOns/"
alias     wow="nocorrect  \cd  /$l/World_of_Warcraft/"
