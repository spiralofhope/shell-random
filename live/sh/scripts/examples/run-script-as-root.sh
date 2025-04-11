#!/usr/bin/env  sh
# Note that some systems may also have $UID or $ID



# As root:
if ! [ "$USER" = 'root' ]; then
  # TODO/FIXME - check if sudo exists
  \echo  'enter root password'
  /bin/su  --command  "$0"
else

# ---
  \echo 'this is run as root'
# ---

fi   # The above is run as root
