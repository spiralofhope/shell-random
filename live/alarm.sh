#!/bin/sh
\echo "Alarm started."
# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $1
# Visual
\echo "alarm" | \leafpad &
# Audio
# TODO - something nicer..
\speaker-test \
  --test wav \
  --nloops 1
