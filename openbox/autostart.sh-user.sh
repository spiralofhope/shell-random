# The global settings are: /etc/xdg/openbox/autostart.sh
# The local master settings are: /home/user/.config/openbox/autostart.sh
# Then this file is run..

\zenity --question
if [ $? -eq 1 ]; then
  exit 1
fi

disconnected(){
  \echo " * Internet connection not detected."
  # I don't do anything special in this case.
}

connected(){
  \echo " * Internet connection detected."

  # IRC
  # X-Chat
  #   It's already configured to auto-connect to servers and join channels.
  #   --minimize=2  =  Minimize to the tray
  #\xchat --minimize=2 &
  # WeeChat
  #   Pops up top-left with no window decorations.
  #   I don't know where this script went.  Oh well.
  #~/bin/weechat.sh &

  # Instant Messaging
  #\empathy &

  # VoIP
  #\twinkle&

  \nice -n 6 \
    /l/Linux/bin/Firefox/firefox -P default &

  # Voice Chat
  # TODO:  How do I get Mumble to automatically connect to a specific server on startup?
  # TODO:  How do I get Mumble to minimize on startup?
  \mumble &

  # Email
  #   Can be started trayed (it gets minimized to the tray after a moment)
  #     but only if I set the tray plugin to do that.
  \claws-mail &
}

# --
# -- Internet connection test
# --

\ping -n -q -w 2 example.com &> /dev/null
if [ $? -eq 2 ]; then
  internet=false
  disconnected
else
  internet=true
  connected
fi

# --
# -- No net connection required for this stuff
# --

# TODO: wmctrl and minimize it.  Heck, toss it on another desktop.
$( \sleep 15 && /l/Linux/bin/sh/projects.sh ) &
