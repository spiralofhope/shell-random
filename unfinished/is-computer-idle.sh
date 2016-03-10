#!/usr/bin/env  zsh

# use case:
# Check if my computer is idle - e.g. has finished all downloads
# If idle, suspend.
# I don't know.. maybe something like this:
# ./idle_check.sh  &&  \sudo  \pm-suspend
# but I'd have to have the user in the sudoers group for this command, so it can suspend unattended



is_cpu_idle(){
  # There's also  `procinfo`  on some systems.  I don't have access to it.
  # There's also  `w`
  # `top`  might have useful info, but perhaps not unattended.

  # Using  `uptime`  like this seems really fucking stupid.
  # Why isn't there a switch to spit out my choice of information?
  local   _1_minute_load_average=$( \uptime  |  \cut  -b 46-49 )
  local   _5_minute_load_average=$( \uptime  |  \cut  -b 52-55 )
  local  _15_minute_load_average=$( \uptime  |  \cut  -b 58-61 )

  # todo - if the number is smaller than (what?)
  # zshism
  if (( $_1_minute_load_average < 0.2 )); then
    return 0
  fi
  return  1
}



is_disk_idle(){
  # Why isn't there a switch to spit out my choice of information?
  disk_activity=$( \cat  /sys/block/sda/stat  |  \cut  -b 91-99 )

  # TODO - poll this over a certain amount of time, and if it hasn't gone up (by much?) then return 0
  return  0
}



# --
# -- The actual work
# --

is_cpu_idle
if  [ $? -ne 0 ]; then
  exit  1
fi

is_disk_idle
if  [ $? -ne 0 ]; then
  exit  1
fi

exit  0
