#!/usr/bin/env  sh



DEBUG=true



_echo() {
  if ! [ -z "$DEBUG" ]; then
    \echo "$*"
  fi
}


_sleep() {
  startTime=$(     \date  --date "now"  +%s )
  startDateTime=$( \date  --date "now"      )
  if [ -z "$*" ]; then
    _echo  "sleeping for 1s (default)"
    timeToWait=1s
  elif [ "$1" = '--date' ]; then
    shift
    _echo  "sleeping until $*"
    # https://stackoverflow.com/questions/645992
    endTime=$(   \date  --date "$*"  +%s )
    timeToWait=$(( $endTime - $startTime ))
    if [ "$timeToWait" -lt 0 ]; then
      \echo  'ERROR:  Time is in the past'
      _echo  "sleeping for 1s (default)"
      timeToWait=1
    fi
    timeToWait=${timeToWait}s
    # TODO:  Is there a way to occasionaly display the remaining time?
    _echo  '' $startTime 'seconds\n' $endTime 'seconds to wait\n' $timeToWait
  else
    _echo  "sleeping for $*"
    timeToWait="$*"
  fi
  \sleep  $timeToWait
  endDateTime=$( \date )
}



_audio_alert() {
  # I don't know how to make it not spam.
  \speaker-test  --test wav  --channels 2  --nloops 1  2> /dev/null
}



# TODO - I could just open a terminal, use Xdialog, zenity or some other such thing.
#        I could also detect for which is available.
_visual_alert() {
  \echo  "$*" | \leafpad &
  _echo
  _echo
  _echo  "$*"
}



# ----------------------------------------------------------------------

_echo  ' * Alarm started'
_sleep  $*
_audio_alert
# Just in case
\killall  -9 speaker-test 2> /dev/null
_visual_alert  "Alarm started at:  $startDateTime  \nAlarm waited for:  $timeToWait  \nAlarm rang at:     $endDateTime"


# To learn the number of seconds remaining, probably:
:<<'learn'
\ps  --user $( \whoami )  -o etimes,args  |\
  \grep  sleep                            |\
  \head  --lines=1                        |\
  \sed  --expression='s/^[[:space:]]*//'  |\
  \cut  --fields=1 --delimiter=' '
learn
# 
:<<'usage'
alarm.sh 1h &   # Remember to not close this terminal!
# (the above command)
# =>
# 1             # The number of seconds it's been running.
usage
# FIXME - This might pick up another command with the name 'sleep'.
#         Exactness would require knowing the process number of sleep (which is doable), then checking that specific process number.
