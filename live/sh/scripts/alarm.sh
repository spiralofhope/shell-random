#!/usr/bin/env  sh



# git-bash:
# To get ANSI working under Windows, use ansicon
#   https://github.com/adoxa/ansicon
# on Windows 10:
#   1. unzip it somewhere.
#   2. open a cmd as admin
#   3. go to its unzipped location, to x64
#   4. ansicon.exe -I
DEBUG=true
SPINNER=1

# git-bash:
# Apparently $PF vanishes for this shell..
#if [ -z "$PF" ]; then
  ## I'm on Linux
  #WINDOWS=
#else
  #WINDOWS=true
#fi

# git-bash:
# env ought to be smart under Linux.
# FIXME - this is not valid under Babun/Cygwin
if [ "$SHELL" = '/usr/bin/bash' ]; then
  WINDOWS=true
else
  # I'm on Linux
  WINDOWS=
fi

if [ -z "$WINDOWS" ]; then
  ESCAPE='\033'
else
  ESCAPE=
fi


# Traditional bar-spinner with these characters:  -\|/
# Save cursor position
\echo -n  "$ESCAPE[s"
spinner() {
  # Restore cursor position
  \echo -n  "$ESCAPE[u"
  if [ -z $SPINNER ]; then return 0 ; fi
  case $SPINNER in
    1)
      \echo  -n  ' - '
      SPINNER=2
    ;;
    2)
      \echo  -n  ' \ '
      SPINNER=3
    ;;
    3)
      \echo  -n  ' | '
      SPINNER=4
    ;;
    *)
      \echo  -n  ' / '
      SPINNER=1
    ;;
  esac
}



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
    _echo  '' $startTime 'seconds'
    _echo  $endTime 'seconds to wait'
    _echo  $sleep_duration
  else
    sleep_duration="$*"
    _echo  "sleeping for $sleep_duration"
  fi

  # Wrap the 'sleep' command, so I can occasionally display how long it's been sleeping for.
  \sleep  $sleep_duration & _pid=$!
  _elapsed_time_seconds=0
  until [ $? = 1 ]; do
    \sleep 1
    # Show that the timer is still ticking.
    spinner

    _elapsed_time_seconds=$(( $_elapsed_time_seconds + 1 ))
    _echo_every_x_seconds=10
    if [ $(( $_elapsed_time_seconds % $_echo_every_x_seconds )) -eq 0 ]; then
      # IDEA - Be fancy.  But that's likely way too annoying.  I'd have to collect all parameters to 'sleep' (like '\sleep 1h 3m 2s' )to convert them to seconds, then convert that back up to h:m:s
      # It's possible to force the user into one consistent format that's more strict than what 'sleep' allows, but that seems wrong to me.
      # If I manage fancyness, I can display the time remaining.
      \echo  ''
      \echo  "slept for $_elapsed_time_seconds seconds out of $sleep_duration"
    fi
    if [ -z "$WINDOWS" ]; then
      \ps  --pid     $_pid | \grep  sleep  > /dev/null
    else  # cygwin
      \ps  --process $_pid | \grep  sleep  > /dev/null
    fi
  done

  endDateTime=$( \date )
}



_audio_alert() {
  if [ -z "$WINDOWS" ]; then
    # TODO - improve
    \speaker-test  --test wav  --channels 2  --nloops 1  2> /dev/null
    # NOTE - this repository has earlier code for chiptune-like sound.
  else   # Windows
    # This does not work (in git-windows):
    #powershell -c echo \`a
    # echo `a in powershell worked one time but never again.
    # echo ^g is supposed to work
    
    # TODO - is there a way to do this without vlc?
    # TODO - detect if vlc is present
    file="C:\Windows\Media\Alarm01.wav"
    "C:\Program Files\VideoLAN\VLC\vlc.exe" \
      --qt-start-minimized \
      ` # Doesn''t work: ` \
      ` # --play-and-exit ` \
      "$file" \
    ` # ` &
  fi
}



_visual_alert() {
  if [ -z "$WINDOWS" ]; then
    # TODO - I could just open a terminal, use Xdialog, zenity or some other such thing.
    # I could also detect for which is available.
    \echo  "$*" | \leafpad &
  else   # Windows
    # Hackish, but don't dismiss simplicity.
    start '' "$3"
  fi
  _echo
  _echo
  _echo  "$1"
  _echo  "$2"
  _echo  "$3"
}



# ----------------------------------------------------------------------

_echo  ' * Alarm started'
_sleep  $*
_audio_alert
if [ -z "$WINDOWS" ]; then
  # Just in case
  \killall  -9 speaker-test 2> /dev/null
fi
_visual_alert \
  "Alarm started at:  $startDateTime" \
  "Alarm waited for:  $sleep_duration" \
  "Alarm rang at:     $endDateTime" \
` # `






# To learn the number of seconds elapsed, probably:
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
