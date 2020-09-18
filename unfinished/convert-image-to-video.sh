#!/usr/bin/env  zsh


# ungh, I can't get this to work...


# in seconds.
VIDEO_DURATION=60
VIDEO_FPS=25


# Defaults
#FILENAME_SOURCE=${FILENAME_SOURCE="$HOME/image.png"}
#FILENAME_TARGET=${FILENAME_TARGET="$HOME/video.avi"}
FILENAME_SOURCE="$1"
FILENAME_TARGET="$2"
VIDEO_LENGTH=$(( VIDEO_FPS * VIDEO_DURATION ))



# `-loop_input` was replaced by `-stream_loop -2`

# shellcheck  disable=2086
#   (I want word splitting)
# shellcheck  disable=2039
#   (non-POSIX shism:  Process substitution)
#   https://unix.stackexchange.com/questions/309547/what-is-the-portable-posix-way-to-achieve-process-substitution/309594#309594
# `-sameq`  was removed, see https://trac.ffmpeg.org/ticket/1835
\ffmpeg  \
  -r  "$VIDEO_FPS"  \
  -i  "$FILENAME_SOURCE"  \
  -i  <( \dd  if=/dev/zero  bs=19200  count=1 )  \
  -stream_loop -2  \
  -vframes  $VIDEO_LENGTH  \
  -f  s16le  \
  "$FILENAME_TARGET"
