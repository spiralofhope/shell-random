# --
# -- My additions to autostart.sh
# --
# Edit autostart.sh and append:
# ~/.config/openbox/autostart.sh-system.sh


# This lingering parent task isn't necessary.
# I don't know of a better way to break out of this subshell nonsense.  `setsid` all over the place hasn't been the answer.
\kill  -9  $( \pgrep --full '/bin/sh /usr/bin/startx' )


{  # Background colour
  #   check out /usr/share/X11/rgb.txt for the list of names
  #   http://bitsy.sub-atomic.com/~moses/decimalcol.html
  # gray3 is slightly off-black.
  \xsetroot  -solid gray3
  # \xsetroot  -solid steelblue
  # \xsetroot  -solid cadetblue
  # \xsetroot  -solid rgb:58/61/43
  # \xsetroot  -solid slategrey
}


{  # Turn on the numlock
  # 2016-03-30, on Slackware 14.1
  #   installed with  `slpkg  -s sbo  numlockx`
  \setsid  \numlockx &
  # (date not recorded), on Lubuntu (version not recoded)
  #   wtf, doesn't seem to work anymore..
  # 2014-05-16, on Lubuntu 14.04
  #   This necessity seems to be gone.
  #\enable_X11_numlock on &
}


{  # Turn the X beep off.
  \xset  b off &
  # Or in ~/.inputrc add:
  # set bell-style none
}


{  # Hide an inactive mouse.
  \setsid  \unclutter  -root  -idle 3 &
}


{  #  Screen saver
  # Just in case:
  \killall  --quiet  gnome-screensaver &

  # This complexity is to prevent screen blanking if xscreensaver is run a second time.  What idiocy..
  #\pidof  xscreensaver
  #if [ "$?" -ne 0 ]; then
  #  \xscreensaver  -no-splash > /dev/null &
  #fi

  # xautolock is a really simple monitor for inactivity.
  # slock is a really simple screen saver/locker.
  \setsid  \xautolock  -time 5  -locker \slock &
}


# Fuck you and your desktop nonsense, you crappy program.
\killall  --quiet  pcmanfm


# This fucking thing is a plague that partially locks up my keyboard.
#   \apt-get  remove  ibus
\killall  --quiet  ibus-daemon


# Force-load .Xdefaults, for rxvt-unicode's colour preferences.
\xrdb  -load ~/.Xdefaults
# Fix urxvt:
\xrdb  -load ~/.Xresources



# This also launches fbpanel
~/l/shell-random/live/sh/scripts/dual-monitors.sh  'right disable'
#~/l/shell-random/live/sh/scripts/dual-monitors.sh  'right enable'

# Wait until fbpanel launches.
# .. because fbpanel might not pick up on an application's tray icon unless fbpanel is started first.
#until pids=$( \pidof  'fbpanel' ) ; do
  #\ps  alx | \grep  -E '.* fbpanel$'
  #\sleep  0.1
#done



{  #  KeepassXC (passwords)
  # https://keepassxc.org/
  # https://github.com/magkopian/keepassxc-debian/releases


keepassxc&


  #\rm  --force  \
    #'/l/.KeePassXC--passwords.kdbx.lock'  \
    #'/mnt/1/windows-data/live/.KeePassXC--passwords.kdbx.lock'

  ## It can be set to load previous databases on startup, but I prefer this..
  #\setsid  /usr/bin/keepassxc  \
    #'/l/KeePassXC--passwords.kdbx'  \
    #'/mnt/1/data-windows/live/KeePassXC--passwords.kdbx' &

#  \rm  --force  \
#    '/l/.KeePassXC--passwords.kdbx.lock'

  # It can be set to load previous databases on startup, but I prefer this..
#  \setsid  /usr/bin/keepassxc  \
#    '/l/KeePassXC--passwords.kdbx'  &
}


# launch any user-specific stuff:
~/.config/openbox/autostart.sh-applications.sh




# This doesn't work here, but only in ~/.xsession :
# exec openbox-session


# Kill the summoning process so I don't have a lingering shell..
# .. doesn't work the way I thought..
# \kill -9 ` \cat /tmp/zsh-launching-startx.ppid `

