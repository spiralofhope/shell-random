#!/usr/bin/env  sh
# shellcheck disable=1001
  # I like my backslashes

# Using the date and time in a variable.
# This is handy for making backup files
# I would recommend this be used like:
#   date_hours_minutes=$(         \date.sh  'minutes' )
#   date_hours_minutes_seconds=$( \date.sh  'seconds' )



# Note that ։ is not the colon character on your keyboard (:)
# date_and_time=$( \date  --utc  +%Y-%m-%d\ %H:%M  )

if [ $# -eq 0 ] || [ "$1" = "seconds" ]; then
      return=$( \date  --utc  +%Y-%m-%d_%H։%M։%S )
else  return=$( \date  --utc  +%Y-%m-%d_%H։%M    )
fi


\echo  "$return"
