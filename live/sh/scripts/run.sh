#!/usr/bin/env  sh



dmenu_run  -i -l 32  -fn "7x14" -nf yellow -nb black -sf black -sb white



return 0

# TODO:  Add lots more.  Check my notes.

  # I compile it.
  \thinglaunch

if [ $? -eq 127 ]; then
  # If I'm using lxpanel..
  \which  lxpanel
  # Re-launch lxpanel if it crashed..
  if [ $? -eq 0 ] && [ x$( \pidof lxpanel ) = "x" ]; then
    \lxpanel &
    # todo - find a more elegant solution..
    \sleep 0.5
  fi
  \lxpanelctl  run
elif [ $? -eq 127 ]; then
  \gnome-panel-control  DASH-run-dialog
elif [ $? -eq 127 ]; then
  \bashrun
fi
