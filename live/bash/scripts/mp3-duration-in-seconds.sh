#!/usr/bin/env  bash



# FIXME - Can/should these bashisms be changed?
#         .. to just be vanilla shell stuff?  Maybe with sed and the like?
#         .. maybe to zshisms?


# 2018-05-02 - 9.74-1 on Devuan-1.0.0-jessie-i386-DVD
# \apt-get  install libimage-exiftool-perl

# 2017-05-31 - 9.74-1 on Devuan 1.0.0-beta
# \apt-get  install exiftool
  
# 2009-03-25 - (version not recorded) on PCLinuxOS (version not recorded)
# \apt-get  install perl-Image-ExifTool



# Using exiftool to convert an mp3's mm:ss duration into seconds.
  # http://www.sno.phy.queensu.ca/~phil/exiftool/
duration=$( \exiftool  -S  -Duration  "$1" )
# =>    Duration: 0:02:05 (approx)
#\echo  "$duration"


# Nuke the starting text:
duration=${duration//Duration: /}
# =>    0:02:05 (approx)
#\echo  "$duration"


duration=${duration// (approx)/}
# =>    0:02:05
#\echo  "$duration"

:<<'}'   # This also works for cutting up the duration:
duration=${duration#Duration: }
duration=${duration%% (approx)}
}

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



:<<'}'   # my earlier work
My earlier work, before I knew about: if [ ${1:(-3):1} = "." ]; then echo ok ; fi

duration=`exiftool -S filename.mp3|grep "Duration:"`
duration=${duration//Duration: /}
duration=${duration// s (approx)/}
duration=${duration// (approx)/}

#duration='6.27'  # 6
#duration='12:30' # 750
unset duration_array i
for i in $(seq 0 $((${#duration} - 1))); do
  duration_array=( "${duration_array[@]}" "${duration:$i:1}" )
done

element_count=${#duration_array[*]}
my_element_number=$(( $element_count - 3 ))
minusthree=${duration_array[my_element_number]}
if [ "$minusthree" = "." ]; then
  duration="6.27 s (approx)"
  # You can extract the decimal value too, if you like.
  # echo ${duration#*.}
  duration=${duration%.*}
else if [ $minusthree = ":" ]; then
  duration=$(( ((${duration%%:*} * 60)) + ${duration#*:} ))
else
  echo "Something's funky about the duration exif returned.  Maybe it gave hh:mm:ss and more code is needed?"
fi ; fi
echo $duration

}
