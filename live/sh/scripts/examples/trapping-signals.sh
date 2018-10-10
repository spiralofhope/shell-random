#!/usr/bin/env  sh
# Tested 2017-10-24 on Devuan 1.0.0-jessie-i386-DVD with dash 0.5.7-4+b1



# Working with a temporary directory like this allows one to fiddle around behind the scenes.  For example, run this in an xterm, kill the xterm and see if the temporary directory is removed or not.
# FIXME - Use the proper tool to make this temp directory.
temporary_directory="/tmp/trap-control-c-break.$$"
# Working with a temporary file like this allows one to know if the teardown is already in progress, so as to not duplicate that effort.
temporary_teardown_file="$temporary_directory/already_tearing_down"



for signal in INT QUIT HUP TERM USR1; do
  trap "
    _teardown
    \touch  "$temporary_teardown_file"
    \trap  -  "$signal"  EXIT
    \kill  --signal  "$signal"  "'"$$"'  "$signal"
done



trap  _teardown  INT
_teardown() {
  # Instead of using a temporary file, and detecting if the teardown is already in progress, I could just un-set the traps:
  unset_traps() {
    __() {
      echo
    }
    for signal in INT QUIT HUP TERM USR1 EXIT; do
      trap __ "$signal"
    done
  }
  #unset_traps

  if [ -f "$temporary_teardown_file" ]; then
    \echo  'Already exiting!'
  else
    \echo  ' * Teardown..'
    \touch  "$temporary_teardown_file"
    for i in $( \seq  3  -1  1 ); do
      \echo  "Exiting in $i.."
      \sleep  1
    done
    \echo
    \rm  --force  --recursive  --verbose  "$temporary_directory"
    exit  0
  fi
}



\echo
\echo  ' * Setup..'
\mkdir  --verbose  "$temporary_directory"

\echo
\echo  ' * Press ^c to test..'
\sleep  999

\echo  'FAILURE'
