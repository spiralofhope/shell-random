# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.


# if [ -z "$DISPLAY" ] && [ $(tty) == /dev/tty1 ]; then
if    [ $( tty ) == /dev/tty1 ] || [ $( tty ) == /dev/tty2 ]; then
  startx
  logout
fi
