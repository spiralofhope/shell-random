#!/usr/bin/env  sh



_go() {
  \echo  " * Processing:    $1"
  \vbrfix  -always  "$1"  out
  \mv  --force  out  "$1"
}



if [ -z $1 ]; then
  for i in *.mp3; do
    _go  "$i"
  done
else
  _go  "$1"
fi
