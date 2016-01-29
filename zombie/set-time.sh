#!/bin/bash

# Tested on Lubuntu 13:10, updated 2013-11-15

# Props to cryos82 for a nudge in the right direction.
#   http://sourceforge.net/tracker/?func=detail&aid=2672844&group_id=180858&atid=894872

# To use:
# - right-click on the clock applet in lxpanel
# - choose "Digital Clock" Settings
# - Action when clicked (default: display calendar)  :  set to this script

# Unfortunately, this very notion destroys the ability to click to view the calendar.

# The string allowed for  date --set=$STRING  is extremely flexible.  See  `info date`  for.. well for some bad documentation.  Supposedly there are examples in there somewhere.  Good luck.

# This might trigger xscreensaver.  Might.  It's not consistent, and I have no clue why.  Back in the day, setting the date and shoving it into the hardware clock would always blank the screen and trigger a screen saver.

\xterm  -e  "\cal ; \read"
_user_input="$( \zenity  --entry  --title="Set Date And Time"  --text="Allowed Formats:\n\nTime:  hh:mm\nTime:  hh:mm:ss\n\nDate:  YYYY-MM-DD\n\nDate and Time:  YYYY-MM-DD hh:mm:ss" )"

if [[ ! -z "$_user_input" ]]; then
  # gksudo acts so alien to sudo, that I can't figure out how to use it in this context.  So I'm forced to use xterm and sudo.  Yes, this makes using zenity completely rediculous.  Sigh.
# _result="$( \xterm  -e  "\cal ; \sudo  \date  --set="$_user_input"" )"
  _result="$( \xterm  -e  "       \sudo  \date  --set="$_user_input"" )"
  if [[ $? -ne 0 ]]; then
    \zenity  --info  --text="$_result"
  else
    \killall  lxpanel
    \lxpanel &
  fi
fi
