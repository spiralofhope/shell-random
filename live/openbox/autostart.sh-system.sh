# --
# -- My additions to autostart.sh
# --
# Edit autostart.sh and append:
# ~/.config/openbox/autostart.sh-system.sh


# Fix Firefox crashes on Flash playing, and fix audio issues:
# Disabled 2014-05-16, as I'm unsure if this is necessary.
#export  XLIB_SKIP_ARGB_VISUALS=1


# Programs to launch at startup
# Background colour
#   check out /usr/share/X11/rgb.txt for the list of names
#   http://bitsy.sub-atomic.com/~moses/decimalcol.html
# gray3 is slightly off-black.
\xsetroot  -solid gray3
# \xsetroot  -solid steelblue
# \xsetroot  -solid cadetblue
# \xsetroot  -solid rgb:58/61/43
# \xsetroot  -solid slategrey


# Start the screen saver
# Replaced by xlock.  This code is here just in case.
\killall  --quiet  gnome-screensaver &
# This complexity is to prevent screen blanking if xscreensaver is run a second time.  What idiocy..
\pidof  xscreensaver
if [ $? -ne 0 ]; then
  \xscreensaver  -no-splash > /dev/null &
fi
# A really simple screen saver/locker.
# FIXME? - Maybe this should be \slock
\xautolock  -time 5  -locker slock &


# TODO - Maybe just some hotkeys for audio control.
# TODO - Maybe another hotkey to pull up a console with an ncurses thing
# audio control
#\kmix &


# Turn on the numlock
# wtf, doesn't seem to work anymore..
# 2014-05-16 this necessity seems to be gone under Lubuntu, 14.04 updated recently.
#\enable_X11_numlock on &


# this must be pretty old.. maybe Unity Linux?:
# \python /usr/bin/smart-applet &


# Turn the X beep off.
\xset  b off &
# Or in ~/.inputrc add:
# set bell-style none


# Hide an inactive mouse.
# Doesn't come with X
\unclutter  -root  -idle 3 &


# Fixes the hotkeys.
# No longer needed as I'm not using wine anymore.
#~/.config/openbox/unwine.sh &


# Fuck you and your desktop nonsense, you crappy program.
\killall  --quiet  pcmanfm


# This fucking thing is a plague that partially locks up my keyboard.
#   \apt-get  remove  ibus
\killall  --quiet  ibus-daemon


# Start the bottom panel
(
  ` # Based on fbpanel ` \
  \lxpanel ||\
  \fbpanel ||\
  ` # May be a bit bloated.. ` \
  \xfce4-panel ||\
  \tint2 \
) &


# launch any user-specific stuff:
~/.config/openbox/autostart.sh-user.sh &



# --
# this doesn't work here, but only in ~/.xsession
# exec openbox-session
