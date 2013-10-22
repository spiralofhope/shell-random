#!/bin/sh
\echo "Alarm started."
# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $*
# Visual
\echo "alarm" | \leafpad &
# Audio
#\speaker-test -t sine -l 1 -p 1
# TODO - something nicer..
\speaker-test \
  --test wav \
  --nloops 1
