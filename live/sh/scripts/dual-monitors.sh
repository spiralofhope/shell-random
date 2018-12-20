#!/usr/bin/env  sh
# 2018-12-20 on devuan_ascii_2.0.0-rc_i386_dvd-1
  # Using the proprietary GeForce legacy drivers direct from NVIDIA:
  #   https://www.nvidia.com/Download/driverResults.aspx/137275/en-us



# monitor_left=''  # n/a
monitor_middle='HDMI-0'  # 1920x1080
#monitor_right='VGA-1'
monitor_right='DVI-D-0'  # 1680x1050


_right_disable() {
  #\xrandr  --output "$monitor_middle"  --auto  --primary  # power on
  \xrandr  --output "$monitor_right"   --off

  # Kill all instances, including the right
  \killall fbpanel
  # Re-launch the middle instance
  \setsid  \fbpanel  --profile  1920x1080.sh  &
}


_right_enable() {
  #\xrandr  --output "$monitor_middle"  --auto  --primary  # power on
  \xrandr  --output "$monitor_right"   --auto             # power on
  \xrandr  --output "$monitor_right"  --right-of "$monitor_middle"

  # shift down:  1080 - 1050 = 30
  \xrandr  --output "$monitor_middle"  --pos 0x-30  --output "$monitor_right"  --pos 1920x0

  # middle
  \setsid  \fbpanel  --profile  1920x1080.sh  &
  # right
  \setsid  \fbpanel  --profile  1680x1050.sh  &
  # e.g.:
  # \xrandr --output HDMI-0  --mode 1920x1080  --left-of DVI-D-0
}



if [ -z $1 ]; then
  __=$( /l/OS/bin-mine/shell-random/git/live/sh/scripts/gui-yesno-dialog.sh 'Enable second monitor?' )
  if [ $__ = 0 ]; then
    _right_enable
  else
    _right_disable
  fi
elif [ $1 == 'right enable' ]; then
  _right_enable
elif [ $1 == 'right disable' ]; then
  _right_disable
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
