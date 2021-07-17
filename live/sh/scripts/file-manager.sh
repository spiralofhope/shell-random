#!/usr/bin/env  sh



starting_directory='/live/__'


if [ -d "$starting_directory" ]; then
  \spacefm  --new-window  --no-saved-tabs  "$starting_directory"
else
  \spacefm  --new-window  --no-saved-tabs  "$HOME"
fi
