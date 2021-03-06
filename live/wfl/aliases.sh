#!/usr/bin/env  sh



wfl_mount_drive() {
  if  ! [ -d "/mnt/$1" ]; then
    \sudo  \mkdir  --parents  "/mnt/$1"
  fi
    \mount | \grep "$1"
    if [ $? = 1 ]; then
      \sudo  \mount  -t drvfs  "$1":  "/mnt/$1"
    fi
  \cd  "/mnt/$1" || exit
}
alias  a:='nocorrect  wfl_mount_drive  a' ; alias  A:='nocorrect  a:'
alias  b:='nocorrect  wfl_mount_drive  b' ; alias  B:='nocorrect  b:'
alias  c:='nocorrect  wfl_mount_drive  c' ; alias  C:='nocorrect  c:'
alias  d:='nocorrect  wfl_mount_drive  d' ; alias  D:='nocorrect  d:'
alias  e:='nocorrect  wfl_mount_drive  e' ; alias  E:='nocorrect  e:'
alias  f:='nocorrect  wfl_mount_drive  f' ; alias  F:='nocorrect  f:'
alias  f:='nocorrect  wfl_mount_drive  g' ; alias  F:='nocorrect  g:'
alias  f:='nocorrect  wfl_mount_drive  h' ; alias  F:='nocorrect  h:'
alias  f:='nocorrect  wfl_mount_drive  i' ; alias  F:='nocorrect  i:'
alias  f:='nocorrect  wfl_mount_drive  j' ; alias  F:='nocorrect  j:'
alias  f:='nocorrect  wfl_mount_drive  k' ; alias  F:='nocorrect  k:'
alias  f:='nocorrect  wfl_mount_drive  l' ; alias  F:='nocorrect  l:'
alias  f:='nocorrect  wfl_mount_drive  m' ; alias  F:='nocorrect  m:'
alias  f:='nocorrect  wfl_mount_drive  n' ; alias  F:='nocorrect  n:'
alias  f:='nocorrect  wfl_mount_drive  o' ; alias  F:='nocorrect  o:'
alias  f:='nocorrect  wfl_mount_drive  p' ; alias  F:='nocorrect  p:'
alias  f:='nocorrect  wfl_mount_drive  q' ; alias  F:='nocorrect  q:'
alias  f:='nocorrect  wfl_mount_drive  r' ; alias  F:='nocorrect  r:'
alias  f:='nocorrect  wfl_mount_drive  s' ; alias  F:='nocorrect  s:'
alias  f:='nocorrect  wfl_mount_drive  t' ; alias  F:='nocorrect  t:'
alias  f:='nocorrect  wfl_mount_drive  u' ; alias  F:='nocorrect  u:'
alias  w:='nocorrect  wfl_mount_drive  v' ; alias  w:='nocorrect  v:'
alias  w:='nocorrect  wfl_mount_drive  w' ; alias  w:='nocorrect  w:'
alias  x:='nocorrect  wfl_mount_drive  x' ; alias  x:='nocorrect  x:'
alias  y:='nocorrect  wfl_mount_drive  y' ; alias  y:='nocorrect  y:'
alias  z:='nocorrect  wfl_mount_drive  z' ; alias  z:='nocorrect  z:'



# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'

alias  vlc='/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe'

# World of Warcraft
alias  addons="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/_dotfiles/Interface/AddOns/ || return"
alias     wow="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/ || return"


screen() {
  if ! [ -d /run/screen ]; then
    \sudo  \mkdir      /run/screen
    \sudo  \chmod 777  /run/screen
  fi
  /usr/bin/screen  "$@"
}
