#!/usr/bin/env  sh
# 2018-05-19 - Dash 0.5.7-4+b1



# FIXME - On Windows:  On a Wednesday, `alarm friday` will produce a very small number for the wait-time.



#debug=true
#debug  '\n\n________________________________________________________________________________\n\n' ; return
SPINNER=true


time_source=$( \date  --date 'now'  +%s )


debug() {
  if [ "$debug" ]; then
    #\printf  "$*"

  reset="${ANSI_escape_code}[0m"
  yellow="${ANSI_escape_code}[33m"
  blackb="${ANSI_escape_code}[40m"

    \printf  "${blackb}${yellow}$*${reset}"
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
  #  -s
  unameOut="$( \uname  --kernel-name )"
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
      ANSI_escape_code=''
      _ps='--process'
    ;;
    # This might be okay for git-bash
    MINGW*|'Linux')
      ANSI_escape_code='\033'
      _ps='--pid'
    ;;
    *)
      _ps='--process'
      ANSI_escape_code=''
    ;;
  esac
  cursor_position_save() {    \echo -n  "$ANSI_escape_code[s" ; }
  cursor_position_restore() { \echo -n  "$ANSI_escape_code[u" ; }
  debug  "$unameOut means _ps=$_ps\n"
  debug  '\n'
}



spinner() {   #  Traditional bar-spinner with these characters:  -\|/
  if [ -z $SPINNER ]; then return 0 ; fi
  \printf  '   '
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
  \printf  '  '
}



_sleep_if_possible(){
  debug  "_sleep_if_possible()  $*\n\n"

  {  # Attempt to sleep
    \sleep  $*  2> /dev/null  &  _pid=$!
  }


  {  #  Check if sleeping was a success.  If so, continue sleeping and perform actions while sleeping.
    # There is no way to:
      # Run the command in the background
      # .. and if it died, learn the error code
      # .. or if it succeeded, learn its process id
    # Therefore I will check for the 'sleep' process.
      # .. if it vanishes immediately then there was an error with the `sleep` command.
      # .. if it remains alive after a while, then `sleep` has valid parameters and sleep is continuing normally.
    _elapsed_time_seconds=0
    loop=0
    until [ $loop -eq 1 ]; do
      \sleep  1
      _elapsed_time_seconds=$(( $_elapsed_time_seconds + 1 ))
      cursor_position_save
      spinner
      \printf  "sleeping until $* - ${_elapsed_time_seconds} seconds elapsed.                  "
      if [ "$debug" ]; then
        \printf  '\n'
      fi
      cursor_position_restore

      check_for_sleep_process() {
        debug  "check_for_sleep_process()  $*\n\n"
        debug  "\ps  "$_ps"  "$1" | \grep  sleep  2> /dev/null\n"
        # This may be required for Windows
        #\ps  "$_ps"  "$1" | \grep  sleep  2> /dev/null

        \ps  "$_ps"  "$1"  > /dev/null  2> /dev/null
        exit_code=$?

        debug  "exiting with $exit_code\n\n"
        return  $exit_code
      }
      check_for_sleep_process  $_pid
      loop=$?
    done
  }

  if [ $_elapsed_time_seconds -gt 1 ]; then
    # `sleep` was a success for more than 1 second.
    return 0
  else
    # `sleep` did not survive after 1 second.
    return 1
  fi
}



get_seconds_using_date(){
  debug  "get_seconds_using_date()  $*\n\n"
  time_target=$( \date  --date "$*"  +%s  2>  /dev/null )
  if [ $? -ne 0 ]; then
    debug  "date invalid:  $*\n"
    return 0
  fi
  time_to_wait=$(( $time_target - $time_source ))
  debug  'time, now -- seconds since "epoch" (1970-01-01 00:00:00 UTC):  '$time_source'\n'
  debug  'time, target:  '$time_target'\n'
  if [ $time_to_wait -lt 2 ]; then
    debug  'time to wait invalid:  '$time_to_wait' returning 0\n'
    time_to_wait=0
  fi
  return  $time_to_wait
}



_sleep() {
  debug  "_sleep()  $*\n\n"
  _sleep_if_possible  $*
  if [ $? -eq 1 ]; then
    get_seconds_using_date  $*
    seconds="$?"
    _sleep_if_possible  "$seconds"
  fi
}


_sleep  $*



# TODO - don't trigger these alerts if the sleep wasn't for very long..
:<<'}'
time_source=$( \date  --date  @$time_source +%s )
time_target=$( \date  --date  'now'         +%s )
time_target=$(( $time_target + 2 ))
if [ $time_target -lt 4 ]; then return; fi
if [ $then -lt 3 ]; then return; fi
}
if [ "$debug" ]; then
  debug  'in debug mode, not triggering alerts\n'
else

  _alert_audio() {
    debug  "_alert_audio()  $*\n\n"
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
        \speaker-test  --test wav  --channels 2  --nloops 1  > /dev/null  2> /dev/null
        # NOTE - this repository has earlier code for chiptune-like sound.
        # I've had speaker-test keep echoing before.  While this hasn't been reproduced lately, I'm going to keep this here just in case:
        \killall  -9 speaker-test 2> /dev/null
    esac
  }



  _alert_visual() {
    debug  "_alert_visual()  $*\n\n"
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
        \echo \
"Alarm!

Started  $( \date  --date  @$time_source  +"%Y-%m-%d - %l:%M:%S %P" )
Ended    $( \date  --date  'now'          +"%Y-%m-%d - %l:%M:%S %P" )
"  | \leafpad &
    esac
  }

  _alert_visual
  _alert_audio
fi




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
