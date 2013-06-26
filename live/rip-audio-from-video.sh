#!/usr/bin/env zsh

# TODO:  Needs to be tested for a video with mp3 audio.  I don't need to unravel and transcode it.  video => mp3 => wav => mp3 is just stupid.

# Note that  \avconv  is a drop-in replacement for the depreciated  \ffmpeg

# FIXME: Revise for bash.

# FIXME - this needs to be carefully reviewed and rewritten.  It's hackish and crufty..

_rip_sanity_check(){
  # TODO: Check for read permissions.
  if [ -z "$1" ]; then
    # FIXME: Help text / examples / etc.
    \echo  "Usage: $( \basename $0 ) filename.ext"
    return  0
  # FIXME - This should probably be smarter..
  elif [ ! -f "$1" ]; then
    \echo  "File doesn't exist:  $1"
    return  1
  fi
  in="$1"
}



_rip_setup(){
  # Tested and works for an AAC-audio video, like with most music videos on YouTube.
  # match mode for everything tagged with (audio)
  # for i in *\(audio\)*; do ~/bin/rip-audio-from-video.sh "$i" aac "$i".mp3; done


  # Learn the codec being used:
  audio_codec=( $( \avconv  -i "$in"  2>&1 | \sed  --quiet  "s/.* Audio: \([^,]*\).*/\1/p" ) )

  # Grab "filename", from "filename.ext".
  match="."
  file_basename=${in%$match*}
  match=

  if [ ! "$audio_codec" = mp3 ]; then
    \echo  "Note:  Adding _ to identify this as a transcoded item."
    mp3="$file_basename _.mp3"
  else
    mp3="$file_basename".mp3
  fi

  # TODO: Figure out how to make a .ogg (audio) file..
  #ogg="$file_basename".ogg
  file_basename=

  working_filename=ripping_temp.$$."$audio_codec"

  # TODO: Check for write permissions in the current directory.
  # TODO: Check that the various working and outfiles don't exist exist (e.g. audiodump.wav)
  # TODO: There's probably a way to string everything together so I don't need a temporary file.  It might even make all of this faster!

}



_rip_go(){
  \echo
  \echo  " *"
  \echo  " * Beginning ..."
  \echo  " *"
  \echo


# This is the advice I found for the more direct way to do the ripping:
#
# for lower quality flash:
# avconv -i somevideo.flv -acodec copy output.mp3
#
# larger videos (flv, mp4) use AAC audio:
# avconv -i somevideo.ext -acodec copy output.aac


  # A quick hack just to get webm ripping working.
  # TODO:  The rest needs to be redone.  The idea is solid, but perhaps there's a better way to implement this.
  EXT=${1##*.}
  case "$EXT" in
    "webm")
      # This depends on libavcodec-extra-52
      \avconv  -i "$1"  -aq 3  "$mp3"
      # An absolute bitrate can be defined like:
      # avconv -i $1 -ab 320k -ar 44100 $mp3
      # Can simply rip the ogg directly out of a webm:
      # avconv -i $1 -vn -acodec copy output.ogg
    ;;
    "flv")
      \avconv  -i "$1"  -aq 3  "$mp3"
    ;;
    *)
      \echo  " * Video => Audio"
      \echo  "$in" "=>" $working_filename
      \echo
      # Can't reduce the number of channels.  Wth.  -ac 2 doesn't work.
      \avconv  -i "$in"  -acodec copy  -ac 2  -vn $working_filename
      # TODO: Check for an error code?
      if [ ! -e $working_filename ]; then
        \echo  "Something went wrong with the rip, aborting."
        return  1
      fi

      \echo  " * Audio => WAV"
      \echo  $working_filename => audiodump.wav
      \echo
      # TODO: Check that audiodump.wav doesn't already exist?
      \mplayer  $working_filename  -ao pcm
      # TODO: Check for an error code.
      \echo
      \mv  --verbose  audiodump.wav $working_filename.wav

      \echo
      \echo  " * WAV => MP3"
      \echo  $working_filename.wav "=>" $working_filename.wav.mp3
      \echo
      # -V0 is a bit silly, seeing as we're transcoding.
      \lame  -V3  $working_filename.wav
      # TODO: Check for an error code.
      # FIXME - this should probably be smarter
      if [ ! -e $working_filename.wav.mp3 ]; then
        \echo  "Something went wrong with the encoding, aborting."
        return 1
      fi

      \echo
      \mv  --verbose  $working_filename.wav.mp3  "$mp3"
    # *)
  esac
}



_rip_vbrfix() {
\echo -----------------------------------
  \ls -al "$1"
\echo -----------------------------------
  \echo  " * Fixing the mp3 length.."
  working_filename=ripping_temp.$$."$audio_codec"

  \vbrfix  -always  -makevbr  "$1"  $working_filename

  \mv  --force  $working_filename  "$1"
  \rm  --force  vbrfix.log  vbrfix.tmp
}



_rip_teardown(){
  \echo
  \rm  --force  --verbose  $working_filename
  \rm  --force  --verbose  $working_filename.wav
}


# --
# -- The actual work
# --

_rip_sanity_check  "$1"
_rip_setup
_rip_go            "$1"
if [[ ! x"$mp3" == "x" ]]; then
  _rip_vbrfix        "$mp3"
fi
_rip_teardown
