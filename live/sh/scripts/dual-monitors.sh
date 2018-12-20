#!/usr/bin/env  sh
# 2018-12-20 on devuan_ascii_2.0.0-rc_i386_dvd-1
#   This is using the legacy proprietary drivers direct from GeForce.


# monitor_left=''  # n/a
monitor_middle='HDMI-0'  # 1920x1080
#monitor_right='VGA-1'
monitor_right='DVI-D-0'  # 1680x1050



if [ -z $1 ]; then
  # TODO - implement a more explicit enable/disable feature..
  __=$( /l/OS/bin-mine/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable second monitor?' )
  if [ $__ = 0 ]; then
    \xrandr  --output "$monitor_middle"  --auto  # power on
    \xrandr  --output "$monitor_right"   --auto  # power on
    \xrandr  --output "$monitor_right"  --right-of "$monitor_middle"

    # e.g.:
    # \xrandr --output HDMI-0  --mode 1920x1080  --left-of DVI-D-0
  else
    \xrandr  --output "$monitor_middle"  --auto  # power on
    \xrandr  --output "$monitor_right"   --off
  fi
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

# List all monitors
\xrandr  --listmonitors


# Learn about your cards:
lspci -k | grep -A 2 -i VGA

lsmod | grep nouveau



You may need to:
\apt-get  install firmware-linux-nonfree


This seems to have issues:
\apt-get  install nvidia-driver



New setup:
\xrandr  --output HDMI-0  --left-of DVI-D-0


\xrandr  --output HDMI-0   --mode 1920x1080
\xrandr  --output DVI-D-0  --mode 1680x1050
NOTES
