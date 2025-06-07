#!/usr/bin/env  sh
# Start WSL2 faster by keeping its VM running, at the cost of idling with more system memory.
# WSL2 normally shuts down the VM when the final console is closed (or when one hasn't been launched on bootup in the first place)
# WSL2 must be run once, for this to take effect.  Auto-start it via some other method.


# As root:
if ! [ "$USER" = 'root' ]; then
  # TODO/FIXME - check if sudo exists
  \echo  'enter root password'
  /bin/su  --command  "$0"
else


\echo "
[boot]
systemd=true" >> /etc/wsl.conf

\systemctl enable cron
\systemctl start  cron


fi   # The above is run as root
