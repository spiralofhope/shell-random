#!/usr/bin/env  sh



flash_pid=$( \sudo  \pidof plugin-container )

if [ $? -eq 0 ]; then
  \kill  $flash_pid
fi
