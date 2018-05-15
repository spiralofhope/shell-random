#!/usr/bin/env  sh

# Problem
# While starting up X
# Spawn a terminal emulator
# Get a basic yes or no


# 0=auto
height=0
width=0
#height=5
#width=19
text="$1"
tempfile=$( \mktemp  --suffix="_gui-yesno-dialog" )
\rm  --force  "$tempfile"


# I suspect I could have solved this with `read`, but I think I'd have 
# to have a second script.


# TODO - use alternate terminals..
\urxvt  -geometry 239x64  -e \
  \dialog  --yesno  "$text"  "$height"  "$width"  --trace  "$tempfile" 2>/dev/null

if [ -f "$tempfile" ]; then
  \rm  --force  "$tempfile"
  \echo  '0'
else
  \echo  '1'
fi
