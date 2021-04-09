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
alias  g:='nocorrect  wfl_mount_drive  g' ; alias  G:='nocorrect  g:'
alias  h:='nocorrect  wfl_mount_drive  h' ; alias  H:='nocorrect  h:'
alias  i:='nocorrect  wfl_mount_drive  i' ; alias  I:='nocorrect  i:'
alias  j:='nocorrect  wfl_mount_drive  j' ; alias  J:='nocorrect  j:'
alias  k:='nocorrect  wfl_mount_drive  k' ; alias  K:='nocorrect  k:'
alias  l:='nocorrect  wfl_mount_drive  l' ; alias  L:='nocorrect  l:'
alias  m:='nocorrect  wfl_mount_drive  m' ; alias  M:='nocorrect  m:'
alias  n:='nocorrect  wfl_mount_drive  n' ; alias  N:='nocorrect  n:'
alias  o:='nocorrect  wfl_mount_drive  o' ; alias  O:='nocorrect  o:'
alias  p:='nocorrect  wfl_mount_drive  p' ; alias  P:='nocorrect  p:'
alias  q:='nocorrect  wfl_mount_drive  q' ; alias  Q:='nocorrect  q:'
alias  r:='nocorrect  wfl_mount_drive  r' ; alias  R:='nocorrect  r:'
alias  s:='nocorrect  wfl_mount_drive  s' ; alias  S:='nocorrect  s:'
alias  t:='nocorrect  wfl_mount_drive  t' ; alias  T:='nocorrect  t:'
alias  u:='nocorrect  wfl_mount_drive  u' ; alias  U:='nocorrect  u:'
alias  v:='nocorrect  wfl_mount_drive  v' ; alias  V:='nocorrect  v:'
alias  w:='nocorrect  wfl_mount_drive  w' ; alias  W:='nocorrect  w:'
alias  x:='nocorrect  wfl_mount_drive  x' ; alias  X:='nocorrect  x:'
alias  y:='nocorrect  wfl_mount_drive  y' ; alias  Y:='nocorrect  y:'
alias  z:='nocorrect  wfl_mount_drive  z' ; alias  Z:='nocorrect  z:'



# -X is to sort by extension.
# alias  ls='\ls  -1  --all  --classify  --color=auto  --show-control-chars  -X'

alias  vlc='/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe'

# World of Warcraft
alias  addons="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/_dotfiles/Interface/AddOns/ || return"
alias     wow="nocorrect  \cd  /mnt/c/live/games/World_of_Warcraft/ || return"
# TODO - Turn this into a procedure, which will know if I use a path, and will convert that path into something Windows-compatible
#        e.g.  /mnt/c means C:\
alias  e='nocorrect  /mnt/c/Windows/explorer.exe  .'


screen() {
  if ! [ -d /run/screen ]; then
    \sudo  \mkdir      /run/screen
    \sudo  \chmod 777  /run/screen
  fi
  /usr/bin/screen  "$@"
}
