#!/usr/bin/env  sh

# 2016-11-25 on Slackware 14.1

# TODO - given an array of strings, run the first program found.
# `setsid`  is to force it to run in its own session, so that there's no lingering zsh process.
  \setsid  \lxpanel &
if [ $? -ne 0 ]; then
  \setsid  \fbpanel &
fi
if [ $? -ne 0 ]; then
  \setsid  \xfce4-panel &
fi
if [ $? -ne 0 ]; then
  \setsid  \tint2 &
fi
