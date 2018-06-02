# /etc/zshenv is the 1st file zsh reads; it's read for every shell, even if started with -f (setopt NO_RCS)
# ~/.zshenv is the same, except that it's _not_ read if zsh is started with -f



# Cygwin / Babun
if [ -d '/cygdrive' ]; then
  exit  0
fi



if [ $( \whoami ) = 'root' ]; then
  __() {
    \smartctl  --quietmode=errorsonly  --smart=on  "$1"
#    \smartctl  --smart=on  "$1"
  }
  __  '/dev/sda'
  __  '/dev/sdb'
fi
