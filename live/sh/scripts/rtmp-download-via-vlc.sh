#!/usr/bin/env  sh



\vlc \
  -I dummy \
  "$1" \
  --sout file/ts:output.mpg \
  vlc://quit \
  ` # `

