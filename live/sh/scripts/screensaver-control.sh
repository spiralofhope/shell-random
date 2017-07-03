#!/usr/bin/env  sh

# Instead of slock, xtrlock (provided by xautolock) works with:
# xtrlock -b

# 2016-11-26, on Devuan
# 2016-11-28, on Slackware 14.1
# 2016-03-26, on Lubuntu (version not recorded)
#             /l/shell-random/git/live/slock-capital-punishment.sh
# I've also used
#   \xscreensaver-demo



screensaver_enable() {
  screensaver_disable
  # ~5 minutes to screen power off
  # I make it a little bit less, to give me a moment to cancel the screen saver.
  \xset  +dpms
  \xset  dpms 0 0 295
  # 5 minutes to activation.
  # `readlink`  is to get the full path of _this_ script.
  # There are ways around using  `readlink`  if this ends up being a problem for others.  See https://stackoverflow.com/questions/4774054/
  \xautolock  -time 5  -locker "`\readlink -f $0` 'locknow'" &
  \echo        enabled
}


screensaver_disable() {
  # Disable monitor power saving.
  \xset  -dpms
  # Disable screen blanking for virtual consoles.
  \xset  s off
  # Disable screen blanking.
  # This does not work with rxvt-unicode.
  \setterm  -blank 0
  # I think this sort of thing is usable for rxvt-unicode:
  # \setterm  pointerBlank false
  # Exit xautolock, preventing slock from being triggered.
  \xautolock  -exit
  \echo       disabled
}


screensaver_locknow() {
  screensaver_disable
  # 7 seconds to screen power off
  # 5 also works, but it takes a little too long to wake most screens up.
  \xset  +dpms
  \xset  dpms 0 0 7
  \slock
  screensaver_enable
}



case "$1" in
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
    __=`/l/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh  'Enable screen saver?'`
    if [ "$__" = 0 ]; then
      screensaver_enable
    else
      screensaver_disable
    fi
  ;;
esac
