#!/usr/bin/env  sh

# Have the script check to see if a program is still running.
# 2020-06-10 on Devuan beowulf_3.0.0_amd64
#   Does not work.  Has not been troubleshooted.



timeout=10



timeout_run(){
  \xclock &
}


timeout_program() {
  \xkill > /dev/null &
  checkpid=$!
}


timeout_running(){
  \echo "It's still running\!"
}


timeout_not_running(){
  \echo "It's no longer running."
}


timeout_run
timeout_program
\sleep $timeout
\kill -0 $checkpid 2> /dev/null
if [ $? -eq 0 ]; then
  timeout_running
else
  timeout_not_running
fi
