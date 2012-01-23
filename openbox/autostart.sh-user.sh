# Anything in this file is run AFTER all of the global stuff is run.

# The global stuff is in /etc/xdg/openbox/autostart.sh
# It is linked within /home/user/.config/openbox/autostart.sh

# ----
# If connected to the internet:
# ----

# Umm, I can't get ping to STFU.
ping -n -q -w 2 example.com
if [ $? = 2 ]; then
  echo "No net connection was detected."
else
# twinkle&

# skype &
#empathy &

# ~/bin/skype-2.1.0.81/skype &

# Unity Linux 10.10
# Unity Linux 11.04
killall gnome-screensaver&
xscreensaver&
gnome-panel&
# Tray applications
# smart-applet&
# It's a bit annoying actually..
# net_applet&

  # IRC client.  Pops up top-left with no window decorations.
#  ~/bin/weechat.sh &

  # Can be started trayed (it gets minimized to the tray after a moment)
  #   but only if I set the tray plugin to do that.  There's no way to just
  #   tell it to tray itself when it's started up by this script.
  claws-mail &
  sleep 4

  ## Ventrilo client...
    #mangler -s xx:xx -u xx -p xx &
    #mangler -s xx:xx -u xx &
fi

# ----
# No net connection is required for this stuff:
# ----

# I start this up because I want to have my local wiki visible.
/home/user/bin/firefox/firefox -P default &

# I can't have this code as an external loaded when the system starts up.. bah.
# Find and enter the highest numbered directory
# FIXME - this doesn't work to go to 0.0.99 instead of 0.0.1
#cdv() {
  #if [ ! "x$1" = "x" ]; then
    ## TODO: Sanity-check on $1 (a directory, exists, whatever)
    #\cd "$1"
  #fi
  ## Translation:  Only directories | only n.n.n format | remove trailing slash.| only the last entry
  #\cd `\ls -1d */ | \grep '[0-9]*\.[0-9]*\.[0-9]' | \sed 's/\///' | \tail -n 1`
#}
#
#sleep 1
#cd /home/user/live/projects/compiled-website/
#cdv
# TODO: Wmctrl to shunt this to another desktop?
#sleep 2
#firefox -new-window ./compiled/index.html &


# TODO: Redo this so that the script checks for medit and launches it as needed.
# Pops up right in the way!  TODO: wmctrl and minimize it.  Heck, toss it on another desktop.
# On my older system I needed to pause some more (15) to make sure this works well.
sleep 10
~/bin/project-notes.txt.sh &
