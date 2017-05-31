#!/usr/bin/env  bash



# FIXME - Can/should these bashisms be changed?
#         .. to just be vanilla shell stuff?  Maybe with sed and the like?
#         .. maybe to zshisms?



duration=`\exiftool  -S  -Duration  "$1"`
# =>    Duration: 0:02:05 (approx)
#\echo  "$duration"


# Nuke the starting text:
duration=${duration//Duration: /}
# =>    0:02:05 (approx)
#\echo  "$duration"


duration=${duration// (approx)/}
# =>    0:02:05
#\echo  "$duration"


# Kill a leading 0
if [ "${duration:0:1}" = "0" ]; then duration="${duration:1}" ; fi
# =>    :02:05
#\echo  "$duration"


# Kill a leading colon
if [ "${duration:0:1}" = ":" ]; then duration="${duration:1}" ; fi
# =>    02:05
#\echo  "$duration"


# Kill a leading 0
# =>    2:05
if [ "${duration:0:1}" = "0" ]; then duration="${duration:1}" ; fi
#\echo  "$duration"



# The actual calculation
case "${duration:(-3):1}" in
  ".") # If it was in seconds, drop the fractions of a second (6.1 => 6)
    duration=${duration%.*}
  ;;
  ":") # If it was in mm:ss, then convert it into seconds.
    duration=$(( ((${duration%%:*} * 60)) + ${duration#*:} ))
    # TODO: Deal with hh:mm:ss here.  Just look at ${duration:(-6):1} for another colon?  Check length first?
  ;;
  *) # Something unexpected happened!
    echo "I was looking for a \".\" or \":\" in" \"$duration\" but I found \"${duration:(-3):1}\"
  ;;
esac



\echo "$duration"
