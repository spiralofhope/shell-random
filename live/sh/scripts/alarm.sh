#!/usr/bin/env  sh
# 2018-05-04 - Dash 0.5.7-4+b1



# FIXME - On Windows:  On a Wednesday, `alarm friday` will produce a very small number for the wait-time.



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
Use ANSICON
  https://blog.spiralofhope.com/?p=37580
  http://ansicon.adoxa.vze.com/
  https://github.com/adoxa/ansicon/releases/latest
on Windows 10:
  1. unzip it somewhere.
  2. open a cmd as admin
       windows-x a
  3. go to its unzipped location, to x64
  4. ansicon.exe -I
}



{   #  Determine what sort of machine we're on
  unameOut="$(uname -s)"
  case "${unameOut}" in
    CYGWIN*)    machine=Cygwin;;
    Darwin*)    machine=Mac;;
    Linux*)     machine=Linux;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
  esac
  #echo ${machine}

  case "${unameOut}" in
    # Babun
    CYGWIN*)
      ESCAPE=
      _ps='--process'
    ;;
    # This might be okay for git-bash
    MINGW*)
      ESCAPE='\033'
      _ps='--pid'
    ;;
    *)
      _ps='--process'
      ESCAPE=
  esac
}



check_for_sleep_process() {
  # PROBLEM - duplicate instances of 'sleep'
  \ps  "$_ps"  $1 | \grep  sleep  > /dev/null
  return  $?
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

  check_for_sleep_process  $1

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
  case "${unameOut}" in
    CYGWIN*|MINGW*)
      powershell.exe -Command '
        [console]::beep(1000,300) ;
        [console]::beep(500,400) ;
        [console]::beep(250,500) ;
        sleep 1 ;
        [console]::beep(1000,300) ;
        [console]::beep(500,400) ;
        [console]::beep(250,500) ;
      '
    ;;
    *)
      # TODO - improve
      \speaker-test  --test wav  --channels 2  --nloops 1  2> /dev/null
      # NOTE - this repository has earlier code for chiptune-like sound.
      # I've had speaker-test keep echoing before.  While this hasn't been reproduced lately, I'm going to keep this here just in case:
      \killall  -9 speaker-test 2> /dev/null
  esac
}



_alert_visual() {
  case "${unameOut}" in
    CYGWIN*)
      # This seems like an okay idea.
      cygstart.exe cmd /K "\
        echo Alarm! & \
        echo. & \
        echo Started $( \date  --date  @$time_source  +"%Y-%m-%d - %l:%M:%S %P" ) & \
        echo Ended   $( \date  --date  'now'          +"%Y-%m-%d - %l:%M:%S %P" ) & \
      "
    ;;
    MINGW*)
      # Hackish, but don't dismiss simplicity.
      start '' "$3"
    ;;
    *)
      # TODO - I could just open a terminal, use Xdialog, zenity or some other such thing.
             # I could also detect which is available.
      # re. `date`:  Unfortunately %l (ell) is space-padded, and I don't want to bother doing anything about that.
      \printf \
'Alarm!\n\n'\
"Started " $( \date  --date  @$time_source  +"%Y-%m-%d - %l:%M:%S %P" ) '\n'\
"Ended   " $( \date  --date  'now'          +"%Y-%m-%d - %l:%M:%S %P" ) '\n'\
| \leafpad &
  esac
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



# TODO - don't trigger these alerts if the sleep wasn't for very long..
:<<'}'
time_source=$( \date  --date  @$time_source +%s )
time_target=$( \date  --date  'now'         +%s )
time_target=$(( $time_target + 2 ))
if [ $time_target -lt 4 ]; then return; fi
if [ $then -lt 3 ]; then return; fi
}
_alert_visual
_alert_audio




:<<'}'   #  Usage
{
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
}
