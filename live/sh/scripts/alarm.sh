#!/usr/bin/env  sh
# 2018-05-04 - Dash 0.5.7-4+b1


#debug=true
#debug  '\n\n________________________________________________________________________________\n\n' ; return
SPINNER=true


time_source=$( \date  --date 'now'  +%s )


debug() {
  if [ "$debug" ]; then
    \printf  "$*"
  fi
}


:<<'}'   #  git-bash:  ANSI under Windows
Use ansicon
  https://github.com/adoxa/ansicon
on Windows 10:
  1. unzip it somewhere.
  2. open a cmd as admin
  3. go to its unzipped location, to x64
  4. ansicon.exe -I
}



{   #  Configuration for git-bash
  # Apparently $PF vanishes for this shell..
  #if [ -z "$PF" ]; then
    ## I'm on Linux
    #WINDOWS=
  #else
    #WINDOWS=true
  #fi

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
}



spinner() {   #  Traditional bar-spinner with these characters:  -\|/
  # Restore cursor position
  \echo -n  "$ESCAPE[u"
  if [ -z $SPINNER ]; then return 0 ; fi
  case $SPINNER in
    1)
      \echo  -n  '-'
      SPINNER=2
    ;;
    2)
      \echo  -n  '\'
      SPINNER=3
    ;;
    3)
      \echo  -n  '|'
      SPINNER=4
    ;;
    *)
      \echo  -n  '/'
      SPINNER=1
    ;;
  esac
}
# Save cursor position
\echo -n  "$ESCAPE[s"




_sleep_if_possible(){
  sleep_duration=$*

  check_for_sleep_process() {
    # PROBLEM - duplicate instances of 'sleep'
    if [ -z "$WINDOWS" ]; then
      \ps  --pid     $1 | \grep  sleep  > /dev/null
    else  # cygwin
      \ps  --process $1 | \grep  sleep  > /dev/null
    fi
    return  $?
  }

  \sleep  $sleep_duration  2>  /dev/null  &  _pid=$!
  # There is no way to:
    # Run the command in the background
    # .. and if it died, learn the error code
    # .. or if it succeeded, learn its process id
  # Therefore I will leverage the timing of the life of the 'sleep' process.  If it died immediately then there was an error, and if it remains alive after a while, then it ran successfully.
  # Assume the sleep process is running
  is_sleep_process_running=0

  debug_every_x_seconds=1
  _elapsed_time_seconds=0
  until [ $is_sleep_process_running -eq 1 ]; do
    \sleep 1
    _elapsed_time_seconds=$(( $_elapsed_time_seconds + 1 ))
    if [ $_elapsed_time_seconds -gt 2 ]; then
      spinner
      if  [ "$debug" ]                                                     &&\
          [ $(( $_elapsed_time_seconds % $debug_every_x_seconds )) -eq 0 ] ; then
            debug  " alarm.sh slept for ${_elapsed_time_seconds} of ${sleep_duration} ($commandline)."
      fi
    fi
    check_for_sleep_process  $_pid
    is_sleep_process_running=$?
  done

  # If the sleep command died it will (probably) have lived for no more than 2 seconds.
  if [ $_elapsed_time_seconds -lt 2 ]; then return 1; fi
}



get_seconds(){
  debug  'time, now -- seconds since "epoch" (1970-01-01 00:00:00 UTC):  '$time_source'\n'
  time_target=$( \date  --date "$*"  +%s  2>  /dev/null )
  if [ $? -ne 0 ]; then
    debug  "date invalid:  $*\n"
    return 0
  fi
  time_to_wait=$(( $time_target - $time_source ))
  debug  'time, target:  '$time_target'\n'
  if [ $time_to_wait -lt 2 ]; then
    debug  'time to wait invalid:  '$time_to_wait'\n'
    time_to_wait=0
  fi
  return  $time_to_wait
}



_alert_audio() {
  if [ -z "$WINDOWS" ]; then
    # TODO - improve
    \speaker-test  --test wav  --channels 2  --nloops 1  2> /dev/null
    # NOTE - this repository has earlier code for chiptune-like sound.
    # I've had speaker-test keep echoing before.  While this hasn't been reproduced lately, I'm going to keep this here just in case:
    \killall  -9 speaker-test 2> /dev/null
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


_alert_visual() {
  if [ -z "$WINDOWS" ]; then
    # TODO - I could just open a terminal, use Xdialog, zenity or some other such thing.
    # I could also detect for which is available.
    \printf  "$*" | \leafpad &
  else   # Windows
    # Hackish, but don't dismiss simplicity.
    start '' "$3"
  fi
}



_sleep() {
  # Brute force, directly using `sleep`
  _sleep_if_possible  $*
  if [ $? -eq 1 ]; then
    #  The brute-force attempt with `sleep` failed.  Fall back to using `date`
    get_seconds  $*
    seconds="$?"
    _sleep_if_possible  "$seconds"
  fi
}


commandline=$*
_sleep  $commandline
if [ $? -ne 0 ]; then return $?; fi


# Using `sleep` directly
# Note that quotes are not valid around this format
  #_sleep  4s
  #_sleep  1h 12s
  #_sleep  1s 4s

# Using `date`
  #_sleep    thursday
  #_sleep    1:23am
  #_sleep    tomorrow 1:23am
  #_sleep    friday 10pm
  #_sleep    friday 10:11:22pm

  #_sleep    invalid


# TODO - don't trigger these alerts if the sleep wasn't for very long..
:<<'}'
time_source=$( \date  --date  @$time_source +%s )
time_target=$( \date  --date  'now'         +%s )
time_target=$(( $time_target + 2 ))
if [ $time_target -lt 4 ]; then return; fi
if [ $then -lt 3 ]; then return; fi
}

_alert_audio

# Unfortunately %l (ell) is space-padded, and I don't want to bother doing anything about that.
_alert_visual  \
'Alarm!\n\n'\
"Started " $( \date  --date  @$time_source  +"%Y-%m-%d - %l:%M:%S %P" ) '\n'\
"Ended   " $( \date  --date  'now'          +"%Y-%m-%d - %l:%M:%S %P" )
