# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.


# if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then
if    [ $( tty ) == /dev/tty1 ] || [ $( tty ) == /dev/tty2 ]; then
# This is a nice idea, but I think I need to chain zsh in the middle of things, unless I want to fuck around with the default shell..  perhaps `dtach` would work, but I don't know..
#  echo $$ !> /tmp/zsh-launching-startx.ppid
#  dtach -n /tmp/dtach.socket  \startx &
  \startx
  \logout
fi
