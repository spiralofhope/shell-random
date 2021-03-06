#!/usr/bin/env  sh
# Launch any available panel (the bottom bar)
# 2018-07-07
#   Devuan-1.0.0-jessie-i386-DVD
#   dash 0.5.7-4+b1


# TODO - given an array of strings, run the first program found.




trytry() {
  # killing ahead of time, in case it's already running.  fbpanel, for one, will allow multiple processes if run in this script's manner, which is really odd.
  # `setsid` is to force it to run in its own session, so that there's no lingering shell parent process.
  #
  \echo  "$1 attempt"
  \killall  "$1"   >  /dev/null 2> /dev/null
  \setsid   "$@"  2>  /dev/null &
  if  \
    _=$( \which "$1" )
  then
    \echo  "$* success"
    exit  0
  fi
  \echo  "$* failed"
}


trytry  fbpanel
trytry  lxpanel
trytry  xfce4-panel
trytry  tint2
