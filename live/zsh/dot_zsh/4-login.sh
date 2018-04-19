# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.
# See also /etc/default/console-setup



\setfont  Uni2-VGA16.psf.gz

# if [ -z "$DISPLAY" ] && [ $( \tty ) == /dev/tty1 ]; then

if    [ "$TTY" = '/dev/tty1' ] ||\
      [ "$TTY" = '/dev/tty2' ]; then

# This is a nice idea, but I think I need to chain zsh in the middle of things, unless I want to fuck around with the default shell..  perhaps `dtach` would work, but I don't know..
#  echo $$ !> /tmp/zsh-launching-startx.ppid
#  dtach -n /tmp/dtach.socket  \startx &

  # Find the TTY number
  #  e.g.  /dev/tty2  =>  2
  string="$TTY"
  pattern='/dev/tty'
  local  tty_to_use=${string##${pattern}}
  tty_to_use=${string##*${pattern}}

  #\setsid  \startx
  # Start X on that specific TTY
  #\setsid  \startx  --  vt"$tty_to_use"
  # Be really specific, so that we can setsid to exit entirely out of zsh or sh:
  \setsid  xinit /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use" -auth $( \tempfile --prefix='serverauth.' )
  \logout
fi
