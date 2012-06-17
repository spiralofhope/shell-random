#!/bin/sh
\echo "Alarm started."
# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $1
# Visual
\echo "alarm" | \leafpad &
# Audio
\speaker-test -t sine -l 1 -p 1
