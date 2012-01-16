# TODO:  Needs to be tested for a video with mp3 audio.  I don't need to unravel and transcode it.  video => mp3 => wav => mp3 is just stupid.

# Tested and works for an AAC-audio video, like with most music videos on YouTube.
# match mode for everything tagged with (audio)
# for i in *\(audio\)*; do ~/bin/rip-audio-from-video.sh "$i" aac "$i".mp3; done

if [ x$1 = x ]; then
  # FIXME: Help text / examples / etc.
  echo Usage: `basename $0` "<filename>"
  return 0
fi

# TODO: Check for read permissions.
if [ ! -f "$1" ]; then
  echo "File doesn't exist: " $1
  return 1
fi
in="$1"

# Learn the codec being used:
audio_codec=( $( \ffmpeg -i "$in" 2>&1 | \sed -n "s/.* Audio: \([^,]*\).*/\1/p" ) )

# Grab "filename", from "filename.ext".
match="."
file_basename=${in%$match*}
match=

if [ ! $audio_codec = mp3 ]; then
  echo Note:  Adding _ to identify this as a transcoded item.
  mp3="$file_basename _.mp3"
else
  mp3="$file_basename".mp3
fi

# TODO: Figure out how to make a .ogg (audio) file..
#ogg="$file_basename".ogg
file_basename=

working_filename=ripping_temp.$$.$audio_codec

# TODO: Check for write permissions in the current directory.
# TODO: Check that the various working and outfiles don't exist exist (e.g. audiodump.wav)
# TODO: There's probably a way to string everything together so I don't need a temporary file.  It might even make all of this faster!

\echo
\echo " *"
\echo " * Beginning ..."
\echo " *"
\echo

\echo " * Video => Audio"
\echo    "$in" "=>" $working_filename
\echo
# Can't reduce the number of channels.  Wth.  -ac 2 doesn't work.
\ffmpeg -i "$in" -acodec copy -ac 2 -vn $working_filename
# TODO: Check for an error code?
if [ ! -e $working_filename ]; then
  echo something went wrong with the rip, aborting
  return 1
fi

\echo " * Audio => WAV"
\echo    $working_filename => audiodump.wav
\echo
# TODO: Check that audiodump.wav doesn't already exist?
\mplayer $working_filename -ao pcm
# TODO: Check for an error code.
\echo
\mv -v audiodump.wav $working_filename.wav

\echo
\echo " * WAV => MP3"
\echo    $working_filename.wav "=>" $working_filename.wav.mp3
\echo
# -V0 is a bit silly, seeing as we're transcoding.
\lame -V3 $working_filename.wav
# TODO: Check for an error code.
if [ ! -e $working_filename.wav.mp3 ]; then
  echo something went wrong with the encoding, aborting
  return 1
fi

\echo
\mv -v $working_filename.wav.mp3 "$mp3"

\echo
\rm -fv $working_filename
\rm -fv $working_filename.wav
