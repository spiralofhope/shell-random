#!/usr/bin/env  sh



if  \
  flash_pid=$( \sudo  /usr/bin/pidof  plugin-container )
then
  \kill  "$flash_pid"
fi
