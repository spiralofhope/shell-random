#!/usr/bin/env  sh

# Instead of slock, xtrlock (provided by xautolock) works with:
# xtrlock -b



screensaver_enable() {
  screensaver_disable

  # ~5 minutes to screen power off
  # I make it a little bit less, to give me a moment to cancel the screen saver.
  \xset  +dpms
  \xset  dpms 0 0 295

  \which  xscreensaver  > /dev/null 2> /dev/null
  if [ $? -eq 0 ]; then
    \xscreensaver  -no-splash &
  else
    #:<<'  }'   #  xautolock/slock
    {
    # 5 minutes to activation.
    # `readlink`  is to get the full path of _this_ script.
    # There are ways around using  `readlink`  if this ends up being a problem for others.  See https://stackoverflow.com/questions/4774054/
    \xautolock  -exit  2>  /dev/null
    \killall  xautolock  2>  /dev/null
    \xautolock  -time 5  -locker "`\readlink -f $0` 'locknow'" &
    }
  fi

  \echo  'screensaver enabled'
}


screensaver_disable() {
  # Disable monitor power saving.
  \xset  -dpms
  # Disable screen blanking for virtual consoles.
  \xset  s off

  :<<'  }'   #  Disable screen blanking.
  {
  # This does not work with rxvt-unicode.
  # This does not work with QTerminal ("xterm-256color")
  \setterm  -blank 0
  \setterm  --blank
  }

  \which  xscreensaver  > /dev/null 2> /dev/null
  if [ $? -eq 0 ]; then
    \xscreensaver-command  -exit
    #\killall  \xscreensaver-demo
  else
    #:<<'    }'   #  xautolock/slock
    {
      # I think this sort of thing is usable for rxvt-unicode:
      # \setterm  pointerBlank false
      # Exit xautolock, preventing slock from being triggered.
      \xautolock  -exit  2>  /dev/null
      \killall  xautolock  2>  /dev/null
    }
  fi

  \echo  'screensaver disabled'
}


screensaver_locknow() {
  # 7 seconds to screen power off
  # 5 also works, but it takes a little too long to wake most screens up.
  \xset  +dpms
  \xset  dpms 0 0 7

  \which  xscreensaver  > /dev/null 2> /dev/null
  if [ $? -eq 0 ]; then
    screensaver_enable
    \xscreensaver-command  -lock
  else
    #:<<'    }'   #  xautolock/slock
    {
      \slock
      screensaver_enable
    }
  fi

  \echo  'screensaver locked'
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
    __=`/l/OS/bin-mine/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh  'Enable screen saver?'`
    if [ "$__" = 0 ]; then
      screensaver_enable
    else
      screensaver_disable
    fi
  ;;
esac
