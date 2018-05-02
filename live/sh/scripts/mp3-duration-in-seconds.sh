#!/usr/bin/env  sh


# 2018-05-02 - 9.74-1 on Devuan-1.0.0-jessie-i386-DVD
# \apt-get  install libimage-exiftool-perl


file="$1"
#debug=true
#file='test.mp3'


if [ ! -f "$file" ]; then
  \echo  "ERROR:  file does not exist:"
  \echo  "$file"
  exit 1
fi


debug() {
  if [ $debug ]; then
    \echo  $*
  fi
}



# Get duration using exiftool
  # http://www.sno.phy.queensu.ca/~phil/exiftool/
duration=$( \exiftool  -S  -Duration  "$file" )
# =>    Duration: 0:02:05 (approx)
debug  exiftool reports "$duration"


#  Nuke the starting text
duration="$( \echo  $duration  |  \sed  "s/Duration: //" )"
# Duration: 0:02:20 (approx)
# => 
# 0:02:20 (approx)
debug  "$duration"


#  Nuke the ending text
duration="$( \echo  $duration  |  \sed  "s/ (approx)//" )"
# 0:02:20 (approx)
# => 
# 0:02:20
debug  "$duration"


hours=$(   \echo  "$duration"  |  \cut -f 1 -d ':' )                    #  0:02:20  =>  0
minutes=$( \echo  "$duration"  |  \cut -f 2 -d ':' )                    #  0:02:20  =>  02
seconds=$( \echo  "$duration"  |  \cut -f 3 -d ':' )                    #  0:02:20  =>  20
debug  hours   "$hours"
debug  minutes "$minutes"
debug  seconds "$seconds"


# Minutes => Seconds
__=$( \expr  "$minutes" \* 60 )                                         #  02  =>  120
debug  "$__"
# Adding
seconds=$( \expr  "$seconds" + "$__" )                                  #  120 + 20  =>  140
debug  "$seconds"


# Hours => Seconds
__=$( \expr  "$hours" \* 60 \* 60 )                                     #  0 * 60 * 60  =>  0
debug  "$__"
# Adding
seconds=$( \expr  "$seconds" + "$__" )                                  #  140 + 0  =>  140
debug  "$seconds"



# The final result
# Duration: 0:02:20 (approx)
# =>
# 140
\echo  "$seconds"
