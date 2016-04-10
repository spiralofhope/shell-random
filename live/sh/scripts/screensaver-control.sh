#!/usr/bin/env  sh


# 2016-03-29, on Slackware 14.1



screensaver_enable() {
  screensaver_disable
  # 5 minutes to activation.
  \xautolock  -time 5  -locker '/mnt/1/linux-data/e/shell-random/git/live/sh/scripts/screensaver-yesno.sh  "locknow"' &
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
  # 7 seconds to screen power off
  \xset  dpms 0 0 7
  \slock
  # 5 minutes to screen power off
  \xset  dpms 0 0 300
  screensaver_enable
}



case $1 in
  enable)
    screensaver_enable
  ;;
  disable)
    screensaver_disable
  ;;
  locknow)
    screensaver_locknow
  ;;
  *)
    __=`/mnt/1/linux-data/e/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable screen saver?'`
    if [[ $__ == 0 ]]; then
      screensaver_enable
    else
      screensaver_disable
    fi
  ;;
esac
