#!/usr/bin/env  sh



# TODO - deduplicate this
if [ -z $1 ]; then
  for i in *; do
    \echo ----- "$i"
    if [ -f "$i" ]; then
      \vbrfix  -always  "$i"  out
      \mv  --force  out  "$i"
    fi
  done
else
  if [ -f "$i" ]; then
    \vbrfix  -always  "$i"  out
    \mv  --force  out  "$i"
  fi
fi
