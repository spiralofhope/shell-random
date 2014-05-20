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



slock_pid=$( get_pid_of_1_2  xautolock  slock )


if ! [ -z $slock_pid ]; then
  \echo  'The slock pid is' $slock_pid
fi


\zenity \
  --question \
  --title='' \
  --text='Do you want slock to be running?'
if [ $? -eq 1 ]; then
  # no, stop slock
  case "$slock_pid" in
    '')
      \echo  "slock wasn't running.  Doing nothing."
    ;;
    *)
      \echo  'slock was running.  Killing slock..'
      \kill  $slock_pid
    ;;
  esac
else
  # yes, run slock
  case $slock_pid in
    '')
      \echo  "slock wasn't running.  Starting slock.."
      \xautolock  -time 5  -locker slock &
    ;;
  *)
    \echo  'slock is already running.  Doing nothing.'
  ;;
  esac
fi
