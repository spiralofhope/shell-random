#!/usr/bin/env  sh



#DRY_RUN=true



:<<'NOTES'

- Begin a timer
- Record keystrokes to a file
- Record a timer to that file


Requirements:
  touch
  date
  dd


Tested on:
  1. Windows 10 git-bash:
     Git-2.10.1-64-bit
     GNU bash, version 4.3.46(2)-release (x86_64-pc-msys)
  2. dash - (version not recorded)

NOTES



setup() {
  _start_time=$(( $( \date  +%s%N ) / 1000000000 ))
  _date_time=$( \date +%Y-%m-%d--%H-%M-%S )
  _filename=remarkable--"$_date_time".txt

  \echo  " * Begin"
  \echo  "   -----"
  \echo  "Press any key to log it"
  \echo  "Press ESCAPE to exit"
  \echo  ''
  if [ -z "$DRY_RUN" ]; then
    \touch  "$_filename"
    # Formatted as comma-separated values (CSV)
    # The header
    \echo  "character pressed,hh:mm:ss,elapsed seconds,$_date_time" >> "$_filename"
    \echo  "Writing to $_filename"
  else
    \echo  "In dry run mode, not writing to a file."
  fi
  \echo  ''
}



go() {
  # This is a literal escape character embedded into this file.  While there may be another way to do this to avoid complications with a text file that has a binary thing in it, I don't know of it offhand and it doesn't seem to matter.
  until [ "$character_pressed" = "" ]; do
    read_char() {
      \stty  -icanon -echo
      \eval  "$1=\$( \dd  bs=1  count=1 2>/dev/null )"
      \stty  icanon echo
    }
    read_char  character_pressed
    _current_time=$(( $( \date  +%s%N ) / 1000000000 ))
    _elapsed_total_seconds=$(( $_current_time - $_start_time ))
    _hh_mm_ss=$( \date -d@$_elapsed_total_seconds -u +%H:%M:%S )
    # Formatted as comma-separated values (CSV)
    _output_string="$character_pressed,$_hh_mm_ss,$_elapsed_total_seconds"
    \echo  "$_output_string"
    if [ -z "$DRY_RUN" ]; then
      \echo  "~~$_output_string" >> "$_filename"
    fi
  done
}



setup
go
