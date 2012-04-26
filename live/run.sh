# TODO:  Add lots more.  Check my notes.

  # I compile it.
  \thinglaunch

if [ $? -eq 127 ]; then
  # LXDE
  # Bugged, appears behind windows.
  \lxpanelctl run
fi

if [ $? -eq 127 ]; then
  \gnome-panel-control DASH-run-dialog
fi

if [ $? -eq 127 ]; then
  \bashrun
fi
