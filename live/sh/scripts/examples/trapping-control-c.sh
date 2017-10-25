#!/usr/bin/env  sh



# https://unix.stackexchange.com/a/240736

# Working with a temporary directory like this allows one to fiddle around behind the scenes.  For example, run this in an xterm, kill the xterm and see if the temporary directory is removed or not.
# FIXME - Use the proper tool to make this temp directory.
temporary_directory="/tmp/trap-control-c-break.$$"
# Working with a temporary file like this allows one to know if the teardown is already in progress, so as to not duplicate that effort.
# TODO - How could I instead ignore signals during the process?
temporary_teardown_file="$temporary_directory/already_tearing_down"


# NOTE - If more signals arrive while executing _teardown, it may be run again.
#        You may want to make sure your cleanup works correctly if invoked several times
#        (and/or ignore signals during its execution)
# NOTE - This does not catch signals passed to its parent.
#        So if you launch a terminal (e.g. xterm), run this script, then close xterm, _teardown will not execute.

for signal in INT QUIT HUP TERM USR1; do
  trap "
    \touch  $temporary_teardown_file
    _teardown
    \trap  -  $signal  EXIT
    \kill  -s $signal  "'"$$"'  "$signal"
done

trap  _teardown  INT
_teardown() {
  if [ -f "$temporary_teardown_file" ]; then
    \echo  'Already exiting!'
  else
    \echo  ' * Teardown..'
    \touch  "$temporary_teardown_file"
    for i in $( \seq  3  -1  1 ); do
      \echo  "Exiting in $i.."
      \sleep  1
    done
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
