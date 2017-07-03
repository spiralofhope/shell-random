#!/usr/bin/env  sh



# Problem:
# Begin a timer, incrementing seconds.
# Record keystrokes to a file, stamped with the timer



#DRY_RUN=true


# ---------------------------------------------------------------------

setup() {
  _start_time=$( \expr $( \date  +%s%N ) / 1000000000 )
  _date_time=$( \date +%Y-%m-%d--%H-%M-%S )
  _filename=remarkable--"$_date_time".txt

  \echo  " * Begin"
  \echo  "   -----"
  \echo  "Press any key to log that key"
  \echo  "Press ESCAPE to exit"
  \echo  ''
  if [ -z "$DRY_RUN" ]; then
    \touch  "$_filename"
    \echo  "$_date_time" >> "$_filename"
    \echo  "Writing to file:  $_filename"
    \echo  ''
  else
    \echo  "In dry run mode, not writing to a file."
    \echo  ''
  fi
}



go() {
  until [ "$character" = "" ]; do
    read_char() {
      \stty -icanon -echo
      \eval  "$1=\$( \dd  bs=1  count=1 2>/dev/null )"
      \stty icanon echo
    }
    read_char character
    _current_time=$( \expr $( \date  +%s%N ) / 1000000000 )
    _elapsed_seconds=$( \expr $_current_time - $_start_time )
    #_date_time=$( \date +%Y-%m-%d--%H-%M-%S )
    if [ "$DRY_RUN" = '' ]; then
      #\echo  "$character,$_elapsed_seconds,$_date_time" >> "$_filename"
      \echo  "~~$character - $_elapsed_seconds" >> "$_filename"
    fi
    #\echo  "$character,$_elapsed_seconds,$_date_time"
    \echo  "$character - $_elapsed_seconds"
  done
}


setup
go


#\echo 'Enter a project name (optional)'
#\read  -p "> "  _project_name
#if [ -z "$_project_name" ]; then
  #\echo  "No project name specified, using default 'remarkable'"
  #_project_name="remarkable"
#fi
#_filename="$_project_name"--"$_date_time".txt
