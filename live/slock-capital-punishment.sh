#!/usr/bin/env  sh



get_pid_of_1_2() {
  # TODO - This can't deal with the process being run by another user and being denied permission to kill their process.
  # Yes, I could also use `pidof`, except it won't work if there are multiple instances or if there is, say, an xautolock which isn't running slock.
  \echo  $( \
    \ps  ax |\
    \grep  $1 |\
    \grep  $2 |\
    \xargs              ` # Trim whitespace ` |\
    \cut \
      -d' ' \
      -f1 \
  )
}



kill_slock_and_disable_power_saving() {
  # Disable monitor power saving.
  \xset  -dpms
  \xset  s off
  \setterm  -blank 0
  # Kill xautolock, preventing slock from being triggered.
  if ! [ -z $xautolock_pid ]; then
    \echo  'killing slock, pid' $xautolock_pid
    \kill  $xautolock_pid
  else
    \echo  "slock wasn't running"
    \exit  1
  fi
}



enable_slock_and_power_saving() {
  # Enable monitor power saving.
  \xset  +dpms
  # 180 seconds = 5 minutes
  \xset  dpms 0 0 180
  \xset  s on
  \setterm  -blank 5
  if [ -z $xautolock_pid ]; then
    \echo  "slock wasn't running.  Starting it."
    # Enable a 5 minute timer to trigger slock.
    \xautolock  -time 5  -locker \slock &
  else
    \echo  'slock is already running, pid' $xautolock_pid
    \exit  1
  fi
}



xautolock_pid=$( get_pid_of_1_2  xautolock  slock )



if   [ "x$1" = "xon" ]; then
  enable_slock_and_power_saving
  exit  0
elif [ "x$1" = "xoff" ]; then
  kill_slock_and_disable_power_saving
  exit  0
fi



\zenity \
  --question \
  --title='' \
  --text='Do you want slock and monitor power saving to be running?'
if [ $? -eq 1 ]; then
  # no, stop slock via xautolock
  kill_slock_and_disable_power_saving
  \exit  0
else
  # yes, run slock via xautolock
  enable_slock_and_power_saving
  \exit  0
fi
