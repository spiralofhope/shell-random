#!/usr/bin/env  sh



trytry() {
  # killing ahead of time, in case it's already running.  fbpanel, for one, will allow multiple processes if run in this script's manner, which is really odd.
  # `setsid` is to force it to run in its own session, so that there's no lingering shell parent process.
  #
  \echo  "$1 attempt"
  \killall  $1   >  /dev/null 2> /dev/null
  \setsid   $*  2>  /dev/null &
  \which    $1   >  /dev/null 2> /dev/null
  if [ $? = 0 ]; then
    \echo  "$* success"
    exit  0
  fi
  \echo  "$* failed"
}



# TODO:  Add lots more.  Check my notes.

trytry  dmenu_run  -i  -l 32  -fn '9x15'
# I compile it.
trytry  thinglaunch
trytry  lxpanelctl  run
trytry  gnome-panel-control  DASH-run-dialog
trytry  xfce4-panel
trytry  bashrun
