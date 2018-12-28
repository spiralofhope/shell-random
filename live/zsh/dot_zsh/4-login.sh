# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.
# See also /etc/default/console-setup



# No need if booting is otherwise set up correctly:
#\setfont  Uni2-VGA16.psf.gz


# This mess lets me use the console login screen as a GUI login manager.

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

#less /usr/bin/startx


# 2018-11-10 - Devuan 2.0.0
# This will open Openbox
#setsid  \startx
nohup  setsid  \startx > /dev/null

# This will open the default stuff (MATE)
#xinit /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use" -auth $( \tempfile --prefix='serverauth.' )


# Earlier successes:
  # Be really specific, so that we can setsid to exit entirely out of zsh or sh:
# As of Devuan 2.0.0 this works as root but not as a user:
#  \setsid  xinit /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use" -auth $( \tempfile --prefix='serverauth.' )

  # Start X on that specific TTY
  #\setsid  \startx  --  vt"$tty_to_use"

# xinit "$client" $clientargs -- "$server" $display $serverargs

\logout
fi
