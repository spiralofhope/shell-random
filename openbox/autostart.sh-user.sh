# The global settings are: /etc/xdg/openbox/autostart.sh
# The local master settings are: /home/user/.config/openbox/autostart.sh
# Then this file is run..

\zenity --question
if [ $? -eq 1 ]; then
  exit 1
fi

disconnected(){
  \echo " * Internet connection not detected."
}

connected(){
  \echo " * Internet connection detected."
  #twinkle&
  #skype &
  #empathy &

  # IRC client.  Pops up top-left with no window decorations.
  #  ~/bin/weechat.sh &

  # Can be started trayed (it gets minimized to the tray after a moment)
  #   but only if I set the tray plugin to do that.  There's no way to just
  #   tell it to tray itself when it's started up by this script.
  \claws-mail &

  # It's already configured to auto-connect to servers and join channels.
  # minimize=2 is the tray
  \xchat --minimize=2 &
}

# ----
# If connected to the internet:
# ----

\ping -n -q -w 2 example.com &> /dev/null
if [ $? -eq 2 ]; then
  internet=false
  disconnected
else
  internet=true
  connected
fi

# ----
# No net connection is required for this stuff:
# ----

# TODO: wmctrl and minimize it.  Heck, toss it on another desktop.
$( \sleep 15 && /l/Linux/bin/sh/projects.sh ) &

# I start this up because I want to have my local wiki visible.
\nice -n 6 /l/Linux/bin/Firefox/firefox -no-remote -P default &

