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
    sleep_duration=1s
  elif [ "$1" = '--date' ]; then
    shift
    _echo  "sleeping until $*"
    # https://stackoverflow.com/questions/645992
    endTime=$(   \date  --date "$*"  +%s )
    sleep_duration=$(( $endTime - $startTime ))
    if [ "$sleep_duration" -lt 0 ]; then
      \echo  'ERROR:  Time is in the past'
      _echo  "sleeping for 1s (default)"
      sleep_duration=1
    fi
    sleep_duration=${sleep_duration}s
    _echo  '' $startTime 'seconds\n' $endTime 'seconds to wait\n' $sleep_duration
  else
    sleep_duration="$*"
    _echo  "sleeping for $sleep_duration"
  fi

  # Wrap the 'sleep' command, so I can occasionally display how long it's been sleeping for.
  \sleep  $sleep_duration & _pid=$!
  _elapsed_time_seconds=0
  until [ $? = 1 ]; do
    \sleep 1
    _elapsed_time_seconds=$(( $_elapsed_time_seconds + 1 ))
    _echo_every_x_seconds=10
    if [ $(( $_elapsed_time_seconds % $_echo_every_x_seconds )) -eq 0 ]; then
      # IDEA - Be fancy.  But that's likely way too annoying.  I'd have to collect all parameters to 'sleep' (like '\sleep 1h 3m 2s' )to convert them to seconds, then convert that back up to h:m:s
      # It's possible to force the user into one consistent format that's more strict than what 'sleep' allows, but that seems wrong to me.
      # If I manage fancyness, I can display the time remaining.
      \echo  "slept for $_elapsed_time_seconds seconds out of $sleep_duration"
    fi
    \ps  --pid $_pid | \grep  sleep  > /dev/null
  done

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
_visual_alert  "Alarm started at:  $startDateTime  \nAlarm waited for:  $sleep_duration  \nAlarm rang at:     $endDateTime"






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
