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


# I suspect I could have solved this with `read`, but I think I'd have 
# to have a second script.

\urxvt  -geometry 239x64  -e \
  \dialog  --yesno  "$text"  $height  $width  --trace  $$.tmp 2>/dev/null

if [ -f $$.tmp ]; then
  \rm  --force  $$.tmp
  \echo  '0'
else
  \echo  '1'
fi
