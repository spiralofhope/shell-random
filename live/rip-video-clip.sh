echo ------------------------------------
echo begin

# TODO:  Use my colour functionality?


# Usage examples:
# 1) -10   - the first 10 seconds
#    10    - (same)
# 2) 10+   - everything after 10 seconds
#    10-   - (same)
# 3) 10-20 - a 10-second-length clip from 10 seconds to 20 seconds


# TODO - check that ffmpeg actually exists, and is executable
# Maybe make this more universal and not require zsh.
# TODO - make sure that ffmpeg and all other tools exist

# TODO: Sanity-check the parameters
if [ x$1 = "x" ]; then
  \echo needs a parameter
  return 1
fi

filename_source="$1"
if [ ! -f "$1" ]; then
  \echo "that file doesn't exist"
  return 1
# TODO: Check that "filename_source is readable
fi

#filename_source="this is a test.ext"
#filename_source="this should match.ext ~~~.ext"

# Check if I have ~~~, as with filename~~~.ext :
if [ x$2 != "x" ]; then
  string="$2"
elif [ ${"${filename_source%.*}"[-3,-1]} = "~~~" ]; then
  # check $filename_source for a coded reference :
  match="~~~"
  # Everything before ~~~ :
  string=${filename_source%$match*}
  # The last word before the ~~~ :
  match=" "
  string=${string##*$match}
  # Note that the sanity check would be done at the receiving end, not this sending end.
else
  # TODO: Help text
  \echo Either pass one filename with the ~~~ code
  \echo Or pass the code with the second parameter.
  return 1
fi

go() {
  # TODO: Sanity-check $1
  # TODO: Way more thorough checking could be done on the basic syntax:
  #   invalid-10, -10-, --10, 10--, -+10, 10a
  #   10-10
  #   20-10
  #   .. other funky characters, code injection or the like.

  match="~~~"
  # Everything before ~~~ :
  original_filename=${filename_source%$match*}
  match=" "
  # Everything before the last word.
  original_filename=${original_filename%$match*}
  match="."
  original_fileext=${filename_source##*$match}

  # TODO: Check that this would be writable:
  filename_target="$original_filename.$original_fileext"

  echo ------------------------------------
  # -y is to overwrite the target.  Might be a bit dangerous.
  \ffmpeg -i ${filename_source} -acodec copy -vcodec copy ${@} -y ${filename_target}
  \echo --
  \echo \ffmpeg -i ${filename_source} -acodec copy -vcodec copy ${@} -y ${filename_target}
  \echo --
  # Catch and process the exit code from ffmpeg.
}

# TODO: Allow hh:mm:ss.miliseconds (eek!)

# -10
before() {
  echo "(the last x) Cutting the head, keeping the tail."
  echo ".. the last $1 seconds."
  duration=( $(ffmpeg -i "$filename_source" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
  hours=(   $(echo $duration | cut -d":" -f1) )
  minutes=( $(echo $duration | cut -d":" -f2) )
  seconds=( $(echo $duration | cut -d":" -f3 | cut -c -2 ) )
  duration_in_seconds=$(( $hours * 3600 + $minutes * 60 + $seconds ))
  start=$(( $duration_in_seconds - $1 ))

  go -ss $start
}

# 10+
after() {
  echo "(the first x) Keeping the head, cutting the tail."
  echo ".. the first $1 seconds."
  # I wonder if there's a way to leverage -itsoffset somehow. If -ss could be a negative number that would solve this whole thing.
  # TODO: remove the use of `sed` and use zsh string processing.
  duration=( $(ffmpeg -i "$filename_source" 2>&1 | sed -n "s/.* Duration: \([^,]*\), start: .*/\1/p") )
  #duration="  Duration: 12:34:56.78, start: 3.000000, bitrate: 4291 kb/s"
  #duration="  Duration: 00:00:20.00, start: 3.000000, bitrate: 4291 kb/s"
  # TODO: remove the use of `cut` and use zsh string processing.
  hours=( $(echo $duration | cut -d":" -f1) )
  minutes=( $(echo $duration | cut -d":" -f2) )
  seconds=( $(echo $duration | cut -d":" -f3 | cut -c -2 ) )
  miliseconds=( $(echo $duration | cut -d"." -f2 | cut -c -2 ) )
  #zmodload zsh/mathfunc
  duration_in_seconds=$(( $hours * 3600 + $minutes * 60 + $seconds ))
  length_desired=$(( $duration_in_seconds - $1 ))
  start=$(( $duration_in_seconds - $length_desired ))
  # Without zsh's mathematics, instead using "bc"
  #duration_in_seconds=( $(echo "($hours*3600+$minutes*60+$seconds)" | bc | cut -d"." -f1) )
  #start=( $(echo "($duration_in_seconds-$length_desired)" | bc | cut -d"." -f1) )

  go -ss $start -t $length_desired
}

# 10
# 10-20
between() {
  echo "Specific range."
  echo ".. from $1 to $2."
  start=$1
  #zmodload zsh/mathfunc
  end=$(( $2 - $1 ))
  go -ss $start -t $end
}

if [ ${"${string}"[-1]} = "+" ]; then
  # 10+ (from 10 onwards)
  after ${"${string}"[1,-2]}
  return 0
elif [ ${"${string}"[-1]} = "-" ]; then
  # 10-
  echo "invalid syntax"
  return 1
elif [ ${"${string}"[1]} = "-" ]; then
  # -10 (the last 10)
  before ${string#*-}
  return 0
else
  # ${#string} is the length of ${string}
  for i in {2..${#string}}; do
    if [ ${i} != ${#string} ]; then
      # 10-20
      if [ "${string[$i,$i]}" = "-" ]; then
        # In case anyone's a smartass.. 8-10 is just as valid as 10-8, they're the same 2 seconds.
        # But no, I'm not going to roll the video backwards for 10-8.  =p
        if [ ${string%-*} -lt ${string#*-} ]; then
          between ${string%-*} ${string#*-}
          return 0
        else
          # Backwards
          between ${string#*-} ${string%-*}
          return 0
        fi
      fi
    else
      # 10 (the first 10)
      between 0 "${string}"
      return 0
    fi
  done
fi


echo "eek!"
return 1
