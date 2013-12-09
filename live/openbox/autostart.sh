#!/bin/bash

# FIXME - this should be runnable with zsh!

# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.

# Set a background color
BG=""
if which hsetroot >/dev/null; then
    BG=hsetroot
else
    if which esetroot >/dev/null; then
	BG=esetroot
    else
	if which xsetroot >/dev/null; then
	    BG=xsetroot
	fi
    fi
fi
# SteelBlue
test -z $BG || $BG -solid "steelblue"

# D-bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
fi

# Make GTK apps look and behave how they were set up in the gnome config tools
if test -x /usr/libexec/gnome-settings-daemon >/dev/null; then
  /usr/libexec/gnome-settings-daemon &
elif which gnome-settings-daemon >/dev/null; then
  gnome-settings-daemon &
# Make GTK apps look and behave how they were set up in the XFCE config tools
elif which xfce-mcs-manager >/dev/null; then
  xfce-mcs-manager n &
fi

# Preload stuff for KDE apps
if which start_kdeinit >/dev/null; then
  LD_BIND_NOW=true start_kdeinit --new-startup +kcminit_startup &
fi

# Run XDG autostart things.  By default don't run anything desktop-specific
# See xdg-autostart --help more info
DESKTOP_ENV=""
if which /usr/lib/openbox/xdg-autostart >/dev/null; then
  /usr/lib/openbox/xdg-autostart $DESKTOP_ENV
fi

# ------------
# My additions
# ------------

# Fix Firefox crashes on Flash playing, and fix audio issues:
export XLIB_SKIP_ARGB_VISUALS=1

# Programs to launch at startup
# Background colour
# xsetroot -solid steelblue &
# xsetroot -solid cadetblue &
# xsetroot -solid rgb:58/61/43
# http://bitsy.sub-atomic.com/~moses/decimalcol.html
# check out /usr/share/X11/rgb.txt for the list of names
# \xsetroot -solid slategrey
# gray3 is just slightly off-black.
\xsetroot -solid gray3

# The initial terminal
# \xterm -fn 9x15 -bg black -fg gray -sl 10000 -geometry 80x24+0+0 &
# \Terminal --geometry 80x24+10+10 &

# Start the screen saver
#\killall gnome-screensaver&
\xscreensaver -no-splash &
# TO DO: Replace this with something less bloated.
# Maybe just some hotkeys for audio control.
# Maybe another hotkey to pull up a console with an ncurses thing
# audio control
#\kmix &
# Turn on the numlock
# wtf, doesn't seem to work anymore..
\enable_X11_numlock on &

# Start the bottom panel

if_exists=0
# TODO - Ugh, this seems overly complicated.. redo?
run_if_exists(){
  if [ $if_exists -eq 0 ]; then
    $@
    if [[ $? -eq 127 || $? -eq 0 ]]; then
      $@
      if [ $? -eq 0 ]; then
        if_exists=1
      fi
    fi
  fi;
}

panel_determination() {
  # Based on fbpanel
  # Seems to crash a lot.  Maybe rework all of this based on my ancient stuff, which automatically re-launches.
  run_if_exists \
    \lxpanel &

  run_if_exists \
    \fbpanel &

  # May be a bit bloated..
  run_if_exists \
    \xfce4-panel &

  run_if_exists \
    \tint2 &
}
panel_run=0
panel_determination

# this must be pretty old.. maybe unity linux?
# \python /usr/bin/smart-applet &

# Turn the X beep off.
\xset b off &
# Or in ~/.inputrc add:
# set bell-style none

# Hide an inactive mouse.
# Doesn't come with X
\unclutter -root -idle 3 &

# Fixes the hotkeys.
~/.config/openbox/unwine.sh &

# launch any user-specific stuff:
~/.config/openbox/autostart.sh-user.sh &

# this doesn't work here, but only in ~/.xsession
# exec openbox-session
