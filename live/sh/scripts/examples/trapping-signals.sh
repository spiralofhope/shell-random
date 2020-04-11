#!/usr/bin/env  sh
# http://man7.org/linux/man-pages/man1/trap.1p.html




#:<<'}'   #  A simple example.
          #  The problem with this example is that if the user presses control-c multiple times, then _control_c() will be queued to run multiple times!
{
  _control_c(){
    \printf  '\ncontrol-c detected..\n'
    \echo  'exiting in 2'  ;  \sleep  1
    \echo  'exiting in 1'  ;  \sleep  1
  }
  \trap  _control_c  INT
  #
  # Place your script here..
  #
  \echo  ''
  \echo  ' * Press control-c to test..'
  \sleep  9999
  exit  1
}




#:<<'}'   #  A fairly simple example.
          #  This example can deal with the user pressing control-c multiple times, but only by killing the entire script.
{
  _control_c(){
    \printf  '\ncontrol-c detected..\n'
    \echo  'exiting in 2'  ;  \sleep  1
    \echo  'exiting in 1'  ;  \sleep  1
  }
  # I am using backslashes correctly.
  # shellcheck disable=1117
  for  signal  in  INT QUIT HUP TERM USR1; do
    trap "
      \printf  '\ntrap'

      # The following will allow signals to completely kill this whole script if control-c is received multiple times:
      \trap  -  \"$signal\"  EXIT

      _control_c
      \kill  -s  \"$signal\"  "'"$$"'  "$signal"
  done
  #
  # Place your script here..
  #
  \echo  ''
  \echo  ' * Press control-c to test..'
  \sleep  9999
  exit  1
}




#:<<'}'   #  A more complex example
          #  This example can deal with the user pressing control-c multiple times, and is aware if it happens.
{
  # Working with a temporary directory like this allows one to fiddle around behind the scenes.  For example, run this in an xterm, kill the xterm and see if the temporary directory is removed or not.
  temporary_directory=$( \mktemp  --directory  --suffix='--trapping_signals' )
  # Working with a temporary file like this allows one to know if the teardown is already in progress, so as to not duplicate that effort.
  temporary_teardown_file="$temporary_directory/already_tearing_down--$$"



  _teardown() {
    # Instead of using a temporary file, and detecting if the teardown is already in progress, I could just un-set the traps:
    unset_traps() {
      __() {
        \echo
      }
      for  signal  in  INT QUIT HUP TERM USR1 EXIT; do
        trap  __  "$signal"
      done
    }
    #unset_traps

    if [ -f "$temporary_teardown_file" ]; then
      \echo  'Already exiting!'
    else
      \echo  ' * Teardown..'
      # make the file
      :>  "$temporary_teardown_file"
      for i in $( \seq  3  -1  1 ); do
        \echo  "Exiting in $i.."
        \sleep  1
      done
      \echo
      \rm  --force  --recursive  --verbose  "$temporary_directory"
      exit  0
    fi
  }
  trap  _teardown  INT



  #
  # Place your script here..
  #
  \echo  ''
  \echo  ' * Press control-c to test..'
  \sleep  9999
  exit  1
}
