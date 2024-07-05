#!/usr/bin/env  sh



for i in 1 2 3 4 5; do
  "$HOME/l/shell-random/live/sh/scripts/spinner.sh"  "$spinner_counter"
  spinner_counter="$?"
  #\echo  "$spinner_counter"
done
