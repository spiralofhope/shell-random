#!/usr/bin/env  sh

# 2016-11-26 on Devuan

# TODO - given an array of strings, run the first program found.
# `setsid`  is to force it to run in its own session, so that there's no lingering zsh process.
echo "trying lxpanel"
\setsid  \lxpanel &
killall -0 lxpanel


if [ $? -ne 0 ]; then
  echo "trying fbpanel"
  \setsid  \fbpanel &
fi
killall -0 fbpanel


if [ $? -ne 0 ]; then
  echo "trying xfce4-panel"
  \setsid  \xfce4-panel &
fi
killall -0 xfce4-panel


if [ $? -ne 0 ]; then
  echo "trying tint2"
  \setsid  \tint2 &
fi
killall -0 tint2
