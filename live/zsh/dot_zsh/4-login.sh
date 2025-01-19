#!/usr/bin/env  zsh
# /etc/zlogin and $HOME/.zlogin
# Read after zshrc, if the shell is a login shell.
# See also /etc/default/console-setup

########  This file cannot be written-to while the system is using it!
# NOTE #  That means you cannot be in X.
########



if  \
  _=$( \which  setfont )
then
  # No need if booting is otherwise set up correctly:
  # This is technically only usable by root, even though this works..
  \setfont  'Uni2-VGA16.psf.gz'
fi



# This lets me use the console login screen as a login manager.
if    [ "$TTY" = '/dev/tty1' ]  \
||    [ "$TTY" = '/dev/tty2' ]  \
||    [ "$TTY" = '/dev/tty3' ]  \
||    [ "$TTY" = '/dev/pts1' ]  \
||    [ "$TTY" = '/dev/pts2' ]  \
||    [ "$TTY" = '/dev/pts3' ]  \
; then
  # For security reasons, logout if this script completes or there is a problem.
  # NOTE - If there is bad code in this script, then it will exit to the prompt.
  _quit() { \logout ; }
  trap _quit $( \kill -l )

  # Find the TTY number
  #  e.g.  /dev/tty2  =>  2
  #echo $TTY
  tty_to_use="$TTY"
  tty_to_use="${tty_to_use#/dev/tty}"
  tty_to_use="${tty_to_use#/dev/pts}"
  #echo $tty_to_use

  \echo  ' * Starting X'
  # 2025-01-15 on Lubuntu 24.04.1 LTS
  # shellcheck disable=2186
  \xinit  /etc/X11/xinit/xinitrc  \
    --  \
    /usr/bin/X  \
    :$(( tty_to_use - 1 ))  \
    vt"$tty_to_use"  \
  &

  # 2025-01-15 - It's been so long that I can't remember what the servauth file is, so let's not use it.  Perhaps it was for remote desktop?
  # I'm using \tempfile, because \mktemp does not support --prefix
  #\xinit  /etc/X11/xinit/xinitrc -- /usr/bin/X :$(( tty_to_use - 1 )) vt"$tty_to_use"  -auth "$( \tempfile  --prefix='serverauth.' )"  &
  \wait
  # Seppuku, summoning _quit because of the TERM signal
  \kill -9 "$$"
fi


return  $?



# if [ -z "$DISPLAY" ] && [ $( \tty ) == /dev/tty1 ]; then


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







:<<'}'  #  Detect network connection
         #  FIXME? - This doesn't necessarily mean "internet connection"
{
  for interface in /sys/class/net/*; do
    \echo "Processing $interface"
    if [ "$interface" = 'lo' ]; then
      \echo  'skipping "lo" (localhost)'
      \echo  '   It is always there so it does not necessarily count as an outside connection.'
      continue
    fi
    if ! _=$( \cat "$interface"/carrier ); then
      \echo  ' * Network connection not detected.'
    else
      \echo  ' * Network connection detected.'
      # FIXME - What the heck is this all about?  I could make a better temp file, but why does this even exist?
      _="/tmp/$( $USER ).autostart-networking-applications"
      \rm  --force  "$_"
      if
        # shellcheck disable=1117
        \dialog  --yesno  "Network connection detected.\n\nAutostart related applications?"  0  0
      then
        # Make the file, the existence of which will prompt Openbox.
        :>  "$_"
      fi
    fi
  done
  \unset  _
}


# This is a nice idea, but I think I need to chain zsh in the middle of things, unless I want to fuck around with the default shell..  perhaps `dtach` would work, but I don't know..
#  echo $$ !> /tmp/zsh-launching-startx.ppid
#  dtach -n /tmp/dtach.socket  \startx &
