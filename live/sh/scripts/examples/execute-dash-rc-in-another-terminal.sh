#!/usr/bin/env  sh



# Temporary file.  See `temporary-files.sh` for more details and examples.
unique_file=$( \mktemp  --suffix=".my_temporary_file.$$" )
# example file:  /tmp/tmp.CjgG1vqFFC.my_temporary_file.17065



\cat  >  "$unique_file"  <<  dash_rc_file
# This script is run when the terminal is executed.
\ls
# Wait for input:
\read  -r  _
exit  $?
dash_rc_file


export  ENV="$unique_file"
\xterm  -e  "dash"


unset  ENV
unset  unique_file
\rm  --force  --verbose  "$unique_file"
