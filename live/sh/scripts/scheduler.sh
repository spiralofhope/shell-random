#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  \echo  "enter root password"
  /bin/su  --command  "$0"
else

set_scheduler() {
  local  drive="$1"
  local  scheduler="$2"

  \echo  'The scheduler is currently'
  \cat  "/sys/block/$drive/queue/scheduler"

  \echo  "$scheduler" > "/sys/block/$drive/queue/scheduler"
}
#set_scheduler  sda  noop
#set_scheduler  sda  deadline
# 2018-04-09 - The default for Devuan-1.0.0-jessie-i386-DVD
set_scheduler  sda  cfq

fi   # The above is run as root
