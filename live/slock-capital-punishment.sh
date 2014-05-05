#!/usr/bin/env  bash



# TODO - This can't deal with the process being run by another user and being denied permission to kill their process.
# Yes, I could also use `pidof`, except it won't work if there are multiple instances or if there is, say, an xautolock which isn't running slock.
slock_pid=$( \
  \ps  ax |\
  \grep  xautolock |\
  \grep  slock |\
  \xargs              ` # Trim whitespace ` |\
  \cut \
    -d' ' \
    -f1 \
)

\echo  'The slock pid is' $slock_pid

\zenity \
  --question \
  --title='' \
  --text='Do you want slock to be running?'
if [ $? -eq 1 ]; then
  # no, stop slock
  if [[ x$slock_pid == 'x' ]]; then
    \echo  "slock isn't running."
  else
    \echo  'killing slock..'
    \kill  $slock_pid
  fi
else
  # yes, run slock
  if [[ x$slock_pid == 'x' ]]; then
    \echo  'starting slock..'
    \xautolock  -time 5  -locker slock &
  else
    \echo  'slock is already running'
  fi
fi
