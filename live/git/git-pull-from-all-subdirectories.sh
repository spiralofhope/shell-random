#!/usr/bin/env  sh
# At least as old as 2014-10-25



for i in *; do
  if [ ! -d "$i" ]; then
    continue
  fi
  \echo
  \echo  '* Processing '"$i"'..'
  \cd  "$i"
  \git  pull
  \cd  -  > /dev/null
  \echo
  \echo  '--'
done
