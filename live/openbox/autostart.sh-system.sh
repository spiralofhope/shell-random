# --
# -- My additions to autostart.sh
# --
# Edit autostart.sh and append:
# ~/.config/openbox/autostart.sh-system.sh



# Fix the resolution of the big screen
\xrandr  --output DVI-D-1  --mode 1920x1080  --pos 0x0



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

# Just in case:
\killall  --quiet  gnome-screensaver &

# This complexity is to prevent screen blanking if xscreensaver is run a second time.  What idiocy..
#\pidof  xscreensaver
#if [ "$?" -ne 0 ]; then
#  \xscreensaver  -no-splash > /dev/null &
#fi

# xautolock is a really simple monitor for inactivity.
# slock is a really simple screen saver/locker.
\xautolock  -time 5  -locker \slock &


# TODO - Maybe just some hotkeys for audio control.
# TODO - Maybe another hotkey to pull up a console with an ncurses thing
# audio control
#\kmix &


# Turn on the numlock
# 2016-03-30, on Slackware 14.1
#   installed with  `slpkg  -s sbo  numlockx`
\numlockx &
# (date not recorded), on Lubuntu (version not recoded)
#   wtf, doesn't seem to work anymore..
# 2014-05-16, on Lubuntu 14.04
#   This necessity seems to be gone.
#\enable_X11_numlock on &


# this must be pretty old.. maybe Unity Linux?:
# \python /usr/bin/smart-applet &


# Turn the X beep off.
\xset  b off &
# Or in ~/.inputrc add:
# set bell-style none


# Hide an inactive mouse.
\unclutter  -root  -idle 3 &


# Fixes the hotkeys.
# No longer needed as I'm not using wine anymore.
#~/.config/openbox/unwine.sh &


# Fuck you and your desktop nonsense, you crappy program.
\killall  --quiet  pcmanfm


# This fucking thing is a plague that partially locks up my keyboard.
#   \apt-get  remove  ibus
\killall  --quiet  ibus-daemon


# Force-load .Xdefaults, for rxvt-unicode's colour preferences.
\xrdb  -load ~/.Xdefaults


# Start the rxvt-unicode daemon
# After it's started, the client can be launched with `urxvtc`.
\urxvtd  --fork  --opendisplay  --quiet


/l/shell-random/git/live/sh/scripts/panel.sh &

# Passwords
# FIXME - 'sleep' is a stupid way to ensure the panel has been launched before adding keepassx.  May not apply to keepassxc
# \sleep 0.3
#
# https://keepassxc.org/
# https://github.com/magkopian/keepassxc-debian/releases
\rm  --force \
  /l/.KeePassXC--passwords.kdbx.lock \
  /mnt/1/data-windows/live/.KeePassXC--passwords.kdbx.lock
# It can be set to load previous databases on startup, but I like this..
/usr/bin/keepassxc  \
  /l/KeePassXC--passwords.kdbx \
  /mnt/1/data-windows/live/KeePassXC--passwords.kdbx &

# launch any user-specific stuff:
~/.config/openbox/autostart.sh-applications.sh &

# FIXME - This is done to ensure this window pops up after the previous one.  I hate this.
\sleep 0.3

# Set up a Virtual Private Network (left to the user's creation)
~/vpn.sh

# FIXME - This is done to ensure this window pops up after the previous one.  I hate this.
\sleep 0.3

# Set up the second display.
/l/shell-random/git/live/sh/scripts/dual-monitors.sh &




# --
# this doesn't work here, but only in ~/.xsession
# exec openbox-session


# Kill the summoning process so I don't have a lingering shell..
# .. doesn't work the way I thought..
# \kill -9 ` \cat /tmp/zsh-launching-startx.ppid `
