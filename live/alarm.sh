#!/bin/sh
\echo "Alarm started."
# Wouldn't it be cool if it could occasional spit out a reminder as to the time left?
\sleep $1 ; \echo "alarm" | \leafpad
