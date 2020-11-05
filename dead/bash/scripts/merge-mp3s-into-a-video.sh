#!/usr/bin/env  bash

# https://blog.spiralofhope.com/?p=67260




rm -f *
 
# [[Merging mp3s]]
# cat mp3s/*.mp3 > combined.mp3
echo "Please wait while combining and re-encoding mp3s.  No progress is shown."
cat mp3s/*.mp3 | lame --vbr-new - --mp3input combined.mp3
 
# [[Determining mp3 duration]]



# ----



duration=`exiftool -S -Duration combined.mp3`
# Nuke the starting text:
duration=${duration//Duration: /}
# 7.62 s (approx)
duration=${duration// s (approx)/}
# 11:23 (approx)
duration=${duration// (approx)/}

# Kill a leading 0
if [ "${duration:0:1}" = "0" ]; then duration="${duration:1}" ; fi

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



# ----



(
xxd -r<<'PNG_FILE'
0000000: 8950 4e47 0d0a 1a0a 0000 000d 4948 4452  .PNG........IHDR
0000010: 0000 000a 0000 000a 0802 0000 0002 5058  ..............PX
0000020: ea00 0000 1549 4441 5418 9563 fcff ff3f  .....IDAT..c...?
0000030: 036e c084 476e 044b 0300 a5e3 0311 e607  .n..Gn.K........
0000040: 23b7 0000 0000 4945 4e44 ae42 6082       #.....IEND.B`.
PNG_FILE
) > movie.png
 
# [[Convert an image into a video, using FFmpeg]]
 
FPS=25
LENGTH=$(($FPS * $duration))
SETTINGS="-y -r $FPS"
ffmpeg $SETTINGS -loop_input -vframes $LENGTH -i movie.png -i combined.mp3 -map 0:0 -map 1:0 movie.avi >/dev/null 2>/dev/null </dev/null
 
# [[Resize a video for YouTube, using FFmpeg]]
ffmpeg -i movie.avi -y -sameq -s 640x360 movie2.avi >/dev/null 2>/dev/null </dev/null
