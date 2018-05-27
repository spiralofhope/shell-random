#!/usr/bin/env  sh



# The global settings are: /etc/xdg/openbox/autostart.sh
# The local master settings are: /home/user/.config/openbox/autostart.sh
# Then this file is run..



_connected_false() {
  # I don't do anything special in this case.
  \echo .
}



_connected_true() {

  #
  # IRC, X-Chat
  #
  #   It's already configured to auto-connect to servers and join channels.
  #   --minimize=2  =  Minimize to the tray
  #\xchat --minimize=2 &

  #
  # IRC, WeeChat
  #
  #/l/shell-random/git/live/terminal.sh  FORCE \
  #  \urxvtc \
  #    -geometry 239x64 \
  #    +sb                   ` # Remove the scroll bar ` \
  #    -e \weechat


  #
  # Instant Messaging
  #
  #\empathy &


  #
  # VoIP
  #
  #\twinkle&
  # TODO:  How do I get Mumble to minimize on startup?
  #/l/bin/mumble.sh


  #
  # Web browser
  #
  /l/Pale\ Moon/go.sh  default &


  #
  # Email
  #
  #   Can be started trayed (it gets minimized to the tray after a moment)
  #     but only if I set the tray plugin to do that.
  \claws-mail &

  #
  # RSS reader
  #
  # Slated to be replaced by.. anything.  Fucking thing can't even open its gui when run once.  Has to be run twice.
  #\liferea &


  #
  # BitTorrent
  #
  \transmission-gtk &


  #
  # File manager
  #
  \spacefm \
    --panel=1 \
    --new-window \
    --no-saved-tabs \
    --reuse-tab \
    /l/ &
}



# --
# -- Network connection test
# --

_connected=
# 'lo' is localhost
for interface in ` \ls /sys/class/net/  |  \grep  --invert-match  lo `; do
  \echo "Processing $interface"
  _result=` \cat /sys/class/net/"$interface"/carrier `
  \echo  "$_result"
  if [ "$_result" = '1' ]; then
    _connected='true'
    \echo  " * Internet connection detected."
  else
    \echo  " * Internet connection not detected."
  fi
done

if [ "$_connected" = 'true' ]; then

  # Set up a Virtual Private Network (left to the user's creation)
  ~/vpn-launch.sh

  __=` /l/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Internet connection detected.\n\nRun internet-related applications?' `
  if [ "$__" -eq 0 ]; then
    _connected_true
  else
    exit 1
  fi
else
  _connected_false
fi


# --
# -- No net connection required for stuff down here.
# --


# An initial terminal
# \xterm  -fn 9x15  -bg black  -fg gray  -sl 10000  -geometry 80x24+0+0 &
# \Terminal  --geometry 80x24+10+10 &
# /l/shell-random/git/live/terminal.sh



# Notes
# TODO: wmctrl and minimize it.  Heck, toss it on another desktop.
/l/shell-random/git/live/sh/scripts/projects.sh
