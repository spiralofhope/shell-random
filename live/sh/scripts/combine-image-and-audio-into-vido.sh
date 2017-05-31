#!/usr/bin/env  sh



_image_filename="$1"
_audio_filename="$2"
_output_filename="$3"

# Warning - avi seems to be huge
#           mov and mp4 seem good



\avconv  \
  -loop 1 \
  -i "$_image_filename"  \
  -i "$_audio_filename"  \
  -shortest  \
  -acodec copy  \
  "$_output_filename"
