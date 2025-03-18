#!/usr/bin/env  sh

# Problem
# While starting up X
# Spawn a terminal emulator
# Get a basic yes or no


# TODO - Learn from terminal.sh to go through all the various terminal and dialog-program (dialog, gdialog, zenity, etc.) options
# TODO - Also consider xdialog, etc


# 0=auto
height=0
width=0
#height=5
#width=19
text="$1"
tempfile="$( \mktemp  --dry-run  --suffix=".my_temporary_file.$$" )"


# I suspect I could have solved this with `read`, but I think I'd have 
# to have a second script.


# TODO - use alternate terminals..
# shellcheck disable=1001
# TODO - somehow use terminal.sh
# Can also do a terminal.sh FORCE /bin/terminal --switch
:<<'}'   #  using a regular terminal (urxvt)
{
  \urxvt  -geometry 239x64  -e \
    \dialog  --yesno  "$text"  "$height"  "$width"  --trace  "$tempfile" 2>/dev/null
  if [ -f "$tempfile" ]; then
    \rm  --force  "$tempfile"
    \echo  '0'
    \return  0
  else
    \echo  '1'
    \return  1
  fi
}



#:<<'}'   #  qterminal
{
  # It doesn't appear to have geometry options
  \qterminal --execute \
    \dialog  --yesno  "$text"  "$height"  "$width"  --trace  "$tempfile" 2>/dev/null
  if [ -f "$tempfile" ]; then
    \rm  --force  "$tempfile"
    \echo  '0'
    \return  0
  else
    \echo  '1'
    \return  1
  fi
}



:<<'}'   #  zenity
# gdialog is a wrapper around zenity
{
  if  \
    _=$( \zenity  --question  --text="$1" )
  then
    \echo  '1'
    \return  0
  else
    \echo  '0'
    \return  1
  fi
}
