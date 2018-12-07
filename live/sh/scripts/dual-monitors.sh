#!/usr/bin/env  sh
# 2017-03-07, on Devuan 1.0.0-beta
# 2016-04-26, on Slackware 14.1
# 2016-05-09, on Lubuntu 14.04.4 LTS or thereabouts



# Fix the resolution of the big screen
\xrandr  --output DVI-D-1  --mode 1920x1080  --pos 0x0

if [ -z $1 ]; then
  # TODO - implement a more explicit enable/disable feature..
  __=$( /l/OS/bin-mine/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable second monitor?' )
  if [ $__ = 0 ]; then
    # Extend the little screen to its left.
    # Note that the main screen is the little one.

    # Turn it on
    \xrandr  --output VGA-1  --auto
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
# More advanced stuff:
# https://ubuntuforums.org/showthread.php?t=240150

# Adding another montior is something like..
\cvt  1680 1050
\xrandr  --addmode VGA-1 1680x1050

\xrandr  --addmode VGA-1 1280x1024
\xrandr  --output VGA-1  --mode  1280x1024


# List all displays and modes:
\xrandr  -q
  VGA-1    --  little screen
  HDMI-1
  DVI-D-1  --  big screen


# Learn about your cards:
lspci -k | grep -A 2 -i VGA

lsmod | grep nouveau
NOTES
