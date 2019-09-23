#!/bin/sh

for i in *; do
  if [ -d "$i"  -a  -f "$i"/go.sh ]; then
    \echo " * Processing $i.."
    \cd  "$i"
    .  ./go.sh
    \cd  -
  fi
done
