#!/usr/bin/env  sh

# 2020-06-10 on Devuan beowulf_3.0.0_amd64
#   Does not work.  Has not been troubleshooted.
# 2019-08-09 on Debian 9.9.0-i386-xfce-CD-1



timeout=3

timeout_run(){
  \xclock &
  checkpid=$!
}

timeout_running(){
  \echo "It's still running."
}

timeout_not_running(){
  \echo "It's no longer running."
}

timeout_run
\sleep $timeout
if  !  \
  \kill -0 $checkpid 2> /dev/null
then
  timeout_running
else
  timeout_not_running
fi
