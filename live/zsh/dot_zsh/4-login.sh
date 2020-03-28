#!/usr/bin/env  zsh
# /etc/zlogin and ~/.zlogin
# Read after zshrc, if the shell is a login shell.
# See also /etc/default/console-setup


########  This file cannot be written-to while the system is using it!
# NOTE #  That means you cannot be in X.
########


# No need if booting is otherwise set up correctly:
# This is technically only usable by root, even though this works..
\setfont  Uni2-VGA16.psf.gz


# This mess lets me use the console login screen as a GUI login manager.

# if [ -z "$DISPLAY" ] && [ $( \tty ) == /dev/tty1 ]; then

if    [ "$TTY" = '/dev/tty1' ] ||
      [ "$TTY" = '/dev/tty2' ] ||
      [ "$TTY" = '/dev/pts1' ] ||
      [ "$TTY" = '/dev/pts2' ]; then



#:<<'}'  #  Detect network connection
         #  FIXME? - This doesn't necessarily mean "internet connection"
{
  # 'lo' is localhost, which is always there so it doesn't count as an outside connection.
  for interface in /sys/class/net/*; do
    if [ "$interface" = 'lo' ]; then continue; fi
    \echo "Processing $interface"
    _result=$( \cat "$interface"/carrier )
    #\echo  "$_result"
    __="/tmp/$( \whoami ).autostart-networking-applications"
    if [ "$_result" = '1' ]; then
      if
        # shellcheck disable=1117
        \dialog  --yesno  "Network connection detected.\n\nAutostart related applications?"  0  0
      then
        \touch        "$__"
      else
        \rm  --force  "$__"
      fi
      \unset  __
    else
      \echo  ' * Network connection not detected.'
      \rm  --force  "$__"
    fi
  done
}




# This is a nice idea, but I think I need to chain zsh in the middle of things, unless I want to fuck around with the default shell..  perhaps `dtach` would work, but I don't know..
#  echo $$ !> /tmp/zsh-launching-startx.ppid
#  dtach -n /tmp/dtach.socket  \startx &

  # Find the TTY number
  #  e.g.  /dev/tty2  =>  2
  string="$TTY"
  # FIXME - make this use either format..
  # I don't know why this works, even though $TTY is actually /dev/pts1
  pattern='/dev/tty'
  #pattern='/dev/pts'
  tty_to_use=''
  tty_to_use="${string##${pattern}}"
  tty_to_use="${string##*${pattern}}"

#less /usr/bin/startx



# Earlier successes:
  # Be really specific, so that we can setsid to exit entirely out of zsh or sh:
# As of Devuan 2.0.0 this works as root but not as a user:
#  \setsid  xinit /etc/X11/xinit/xinitrc -- /usr/bin/X :$( \expr "$tty_to_use" - 1 ) vt"$tty_to_use" -auth $( \tempfile --prefix='serverauth.' )

  # Start X on that specific TTY
  #\setsid  \startx  --  vt"$tty_to_use"

# xinit "$client" $clientargs -- "$server" $display $serverargs




# 2018-11-10 - Devuan 2.0.0
#
# This will open Openbox
#setsid  \startx
#\logout


# 2018-12-28 - Devuan 2.0.0 before new computer
#
# This will open Openbox
#nohup  setsid  \startx > /dev/null
#\logout


# 2018-12-29 - Devuan 2.0.0 after new computer
#
# Launches X but doesn't switch to it:
#startx
# Launches X but doesn't switch to it:
#setsid  \startx
# Launches X but doesn't switch to it:
#nohup  setsid  \startx > /dev/null

# 2020-03-26 success
# mktemp does not support --prefix
# shellcheck disable=2186
\xinit  /etc/X11/xinit/xinitrc -- /usr/bin/X :$(( tty_to_use - 1 )) vt"$tty_to_use"  -auth "$( \tempfile  --prefix='serverauth.' )"
logout


:<<'}'
{
  \xinit  /etc/X11/xinit/xinitrc  \
    --  \
    /usr/bin/X  \
    :$(( tty_to_use - 1 ))  \
    vt"$tty_to_use"  &
  \wait
  # FIXME - This also logs out of every console:
  \logout
}



fi  # ttys 1,2
