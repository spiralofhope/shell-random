#!/usr/bin/env  sh

# https://unix.stackexchange.com/a/240736


dir=/tmp/trap-control-c-break.$$



# NOTE - If more signals arrive while executing _teardown, it may be run again.
#        You may want to make sure your cleanup works correctly if invoked several times
#        (FIXME - how? - and/or ignore signals during its execution)
# NOTE - This does not catch signals passed to its parent.
#        So if you launch a terminal (e.g. xterm), run this script, then close xterm, _teardown will not execute.
for sig in INT QUIT HUP TERM USR1; do
  trap "
    _teardown
    trap - $sig EXIT
    kill -s $sig "'"$$"' "$sig"
done
trap _teardown EXIT
_teardown() {
  \echo  ' * Teardown signalled..'
  \rmdir  --verbose  "$dir"
}



\echo  ' * Setting up..'
\mkdir  --verbose  "$dir"
\echo  ' * Press ^c to test..'
sleep  999
\echo  'FAILED'
#_teardown
