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



xautolock_pid=$( get_pid_of_1_2  xautolock  slock )


if ! [ -z $xautolock_pid ]; then
  \echo  'The slock pid is' $xautolock_pid
fi


\zenity \
  --question \
  --title='' \
  --text='Do you want slock and monitor power saving to be running?'
if [ $? -eq 1 ]; then
  # no, stop slock via xautolock
  case "$xautolock_pid" in
    '')
      \echo  "slock wasn't running.  Doing nothing."
    ;;
    *)
      \echo  'slock was running.  Killing slock and disabling power saving..'
      # Kill xautolock, preventing slock from being triggered.
      \kill  $xautolock_pid
      # Disable monitor power saving.
      \xset  -dpms
    ;;
  esac
else
  # yes, run slock via xautolock
  case $xautolock_pid in
    '')
      \echo  "slock wasn't running.  Starting slock and enabling power saving.."
      # Enable a 5 minute timer to trigger slock.
      \xautolock  -time 5  -locker \slock &
      # Enable monitor power saving.
      \xset  +dpms
      # 180 seconds = 5 minutes
      \xset  dpms 0 0 180 \
    ;;
  *)
    \echo  'slock is already running.  Doing nothing.'
  ;;
  esac
fi
