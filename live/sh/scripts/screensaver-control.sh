#!/usr/bin/env  sh


# 2016-03-29, on Slackware 14.1



screensaver_enable() {
  screensaver_disable
  # 5 minutes to activation.
  \xautolock  -time 5  -locker '/mnt/1/linux-data/e/shell-random/git/live/sh/scripts/screensaver-yesno.sh  "locknow"' &
#  \xautolock  -time 5  -locker '\xset  +dpms  ;  \xset  dpms 0 0 5  ;  \slock  \xset  dpms 0 0 300' &
#  # 5 minutes to turn off the monitor.
#  #\xset  dpms 0 0 300
  \echo        enabled
}


screensaver_disable() {
  # Disable monitor power saving.
  \xset  -dpms
  # Disable screen blanking for virtual consoles.
  \xset  s off
  # Disable screen blanking.
  \setterm  -blank 0
  # Exit xautolock, preventing slock from being triggered.
  \xautolock  -exit
  \echo       disabled
}


screensaver_locknow() {
  screensaver_disable
  \xset  +dpms
  \xset  dpms 0 0 5
  # I've seen no combination of this work.
  #\slock  \xset  dpms 0 0 300
  \slock
  \xset  dpms 0 0 300
  screensaver_enable
}



if [[ x$1 == 'xenable' ]]; then
  screensaver_enable
elif [[ x$1 == 'xdisable' ]]; then
  screensaver_disable
elif [[ x$1 == 'xlocknow' ]]; then
  screensaver_locknow
else
  __=`/mnt/1/linux-data/e/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable screen saver?'`
  if [[ $__ == 0 ]]; then
    screensaver_enable
  else
    screensaver_disable
  fi
fi
