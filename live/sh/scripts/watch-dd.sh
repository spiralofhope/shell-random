#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  \echo  "enter root password"
  \sudo  "$0"
else

\watch  --interval 5  \
  '\kill  -USR1  "$( \pgrep ^dd )"'

fi   # The above is run as root
