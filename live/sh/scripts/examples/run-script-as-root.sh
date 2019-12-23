#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  \echo  'enter root password'
  /bin/su  --command  "$0"
else

# ---
  \echo 'this is run as root'
# ---

fi   # The above is run as root
