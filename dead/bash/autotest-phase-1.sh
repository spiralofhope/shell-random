#!/usr/bin/env  bash



:<<'NOTES'
= Phase one =

Todo:
* If it errors, setopt -x and re-run it!

Perhaps to do:  Make everything in one mega-script:
# Browse for a file to edit like this.
# Spawn the appropriate editor
# Spawn an [[xterm]] and begin tracking.


How it works:
# One terminal is open, and this script is run.
# Elsewhere, you edit $CHECKFILE
# When a change is seen (the time changes), it is re-run.
NOTES

CHECKFILE="/tmp/checkfile"

check_time() {
  # example:
  # -rw-rw-r-- 1 4 2009-03-29 13:34:56.000000000 -0700 /tmp/checkfile
  time=`ls -gG --full-time "$1" 2> /dev/null`
  time="${time:15:29}"
  # example:
  # 2009-03-29 13:34:56.000000000
  echo "$time"
}

time=`check_time "$CHECKFILE"`

until [ "sky" = "falling" ]; do
  newtime=`check_time "$CHECKFILE"`
  if [ ! "$newtime" = "$time" ]; then time=$newtime ; clear ; source "$CHECKFILE" ; fi
  sleep 2s
  # Kindof cool.  Not so useful once the entire terminal fills up.  =)
  printf "."
done
