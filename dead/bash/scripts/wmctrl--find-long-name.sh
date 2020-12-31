#!/usr/bin/env  bash


# I don't believe this is my code; source not recorded.
# I don't recall testing this.


# Return focus to the original console.
# grep -w to make sure that I don't match the leftmost column and get two lines.
# There's got to be a better way to accomplish this without using grep or hostname.
# This will generate $1 $2 etc..
THEPID=$PPID
wmctrl -l -p|grep -w $THEPID
set `wmctrl -l -p|grep -w $THEPID 2> /dev/null &`
# I'm not sure why I need to stick this in a variable..
string=$@
# left unquoted to kill the beginning space
string=${string#*`hostname`}
string=${string:1}
wmctrl -F -a "$string"
echo wmctrl -F -a "$string"


# Make a regex which can grab everything after the fourth word?  Then I can get rid of `hostname`
# if [[ $@ =~ (magic_regex) ]]; then : ; fi ; echo ${@%$$BASH_REMATCH*}
