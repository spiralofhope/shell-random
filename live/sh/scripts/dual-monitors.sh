#!/usr/bin/env  sh
# 2017-03-07, on Devuan 1.0.0-beta
# 2016-04-26, on Slackware 14.1
# 2016-05-09, on Lubuntu 14.04.4 LTS or thereabouts


# Fix the resolution of the big screen
\xrandr  --output DVI-D-1  --mode 1920x1080  --pos 0x0

if [ -z $1 ]; then
  # TODO - implement a more explicit enable/disable feature..
  __=`/l/e/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable second monitor?'`
  if [ $__ = 0 ]; then
    # Extend the little screen to its left.
    # Note that the main screen is the little one.

    # This puts the little screen on the left:
    # xrandr  --output DVI-D-1  --pos 1080x0
    # This puts the little screen on the right:
    \xrandr  --output DVI-D-1  --pos -1920x0
  else  # disable the second screen
    \xrandr  --output VGA-1  --off
  fi
else
  # Useful for shifting things around, in case I run this script twice in a row by mistake.
  \xrandr  --output DVI-D-1  --pos 1920x0
fi



:<<NOTES
# List all displays and modes:
\xrandr  -q

VGA-1    --  little screen
HDMI-1
DVI-D-1  --  big screen
NOTES
