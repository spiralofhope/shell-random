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
  #\setsid  \xchat --minimize=2 &

  #
  # IRC, WeeChat
  #
  #\setsid  $HOME/l/shell-random/live/terminal.sh  FORCE \
  #  \urxvtc \
  #    -geometry 239x64 \
  #    +sb                   ` # Remove the scroll bar ` \
  #    -e \weechat


  #
  # Instant Messaging
  #
  #\setsid  \empathy &


  #
  # VoIP
  #
  #\setsid  \twinkle&
  # TODO:  How do I get Mumble to minimize on startup?
  #\setsid  /l/bin/mumble.sh


  #
  # Web browser
  #
:<<'}'
{
  profile_name='default'
  '/l/OS/bin/Pale Moon/delete_parentlock.sh'       "$profile_name"
  \setsid  '/l/OS/bin/Pale Moon/_installation/palemoon'  -P "$profile_name"  -new-tab "about:blank" &
}
\setsid  palemoon &
\setsid  brave-browser &


  #
  # Email
  #
  #   Can be started trayed (it gets minimized to the tray after a moment)
  #     but only if I set the tray plugin to do that.
  \setsid  \claws-mail &

  #
  # RSS reader
  #
  # Slated to be replaced by.. anything.  Fucking thing can't even open its gui when run once.  Has to be run twice.
  #\setsid  \liferea &


  #
  # BitTorrent
  #
  #\setsid  \transmission-gtk &


  #
  # File manager
  #
  \setsid  \
    \spacefm  \
      --panel=1  \
      --new-window  \
      --no-saved-tabs  \
              --reuse-tab  \
              --new-tab  /live/           &&  \
    \spacefm  --new-tab  /live/projects/  &&  \
    \spacefm  --new-tab  /live/__/        &

}



# --
# -- Network connection test
# --

_connected=

# This was moved into .zsh/4-login.sh
:<<'}'  #  Working method
{
  # 'lo' is localhost
  for interface in $( \ls /sys/class/net/  |  \grep  --invert-match  lo ); do
    \echo "Processing $interface"
    _result=$( \cat /sys/class/net/"$interface"/carrier )
    \echo  "$_result"
    if [ "$_result" = '1' ]; then
      _connected='true'
      \echo  " * Internet connection detected."
    else
      \echo  " * Internet connection not detected."
    fi
  done
}
#
:<<'}'   # Ping the default gateway.  Doesn't seem to always work.
{
  # GW=$( \ip  route list  |  \sed -rn 's/^default via ([0-9a-f:.]+) .*/\1/p' )
  # 40% slower, but easier to read:
  GW=$( \ip  route list  |  \awk  '($1 == "default") {print $3}' )
  # I don't know how to shut it up.
  \ping  -c 1  -q  "$GW" 2> /dev/null
  if [ $? -eq 0 ]; then
    _connected='true'
    \echo  " * Internet connection detected."
  else
    \echo  " * Internet connection not detected."
  fi
}



#:<<'}'   #  Act on the internet connection information provided by 4-login.sh
{
  __="/tmp/$( $USER ).autostart-networking-applications"
  if  [ -f  "$__" ]; then
    _connected_true
  else
    _connected_false
  fi
  # I could keep it if I wanted to do more things with that knowledge:
  \rm  --force  "$__"
  unset  __
}



# --
# -- No net connection required for stuff down here.
# --


# An initial terminal
# \xterm  -fn 9x15  -bg black  -fg gray  -sl 10000  -geometry 80x24+0+0 &
# \Terminal  --geometry 80x24+10+10 &
# \setsid  $HOME/l/shell-random/live/terminal.sh



# Notes
# TODO: wmctrl and minimize it.  Heck, toss it on another desktop.
\setsid  $HOME/l/shell-random/live/sh/scripts/projects-open.sh &

# Maybe if I put this here it will work..
$HOME/l/shell-random/live/sh/scripts/screensaver-control.sh  disable
