#!/bin/sh



debug=true

# FIXME - must not be run as root
# TODO - It's stupid of me to house files and directories without their leading dot.  Untangle this.

if [ -z $1 ]; then
  dot='.'
fi
date="$( \date +%Y-%m-%d--%H-%M-%S )"


\echo  ""
\echo  " * Preparing home/user/ dot files.."
for i in *; do
  if [ ! -f "$i" ]; then
    continue
  fi
  if [ "$i" = 'go.sh' ]; then
    continue
  fi
  if [ $debug ]; then
    \echo  "$i"
  fi
  # Back up any existing files.
  # If a file and not a symlink.
  if [ -f ~/"$dot""$i" -a ! -L ~/"$dot""$i" ]; then
    \mv  ~/"$dot""$i"  ~/"$dot""${i}"--"$date"
  fi
  \ln  --force  --no-target-directory  --symbolic  "$PWD"/"$i"  ~/"$dot""$i"
done


\echo  ""
\echo  " * Preparing home/user/ dot directories.."
for i in *; do
  if [ ! -d "$i" ]; then
    continue
  fi
  # Back up any existing directories.
  # If a directory and not a symlink.
  if [ -d ~/"$dot""$i" -a ! -L ~/"$dot""$i" ]; then
    \mv  ~/"$dot""$i"  ~/"$dot""${i}"--"$date"
  fi
  \ln  --force  --no-target-directory  --symbolic  "$PWD"/"$i"  ~/"$dot""$i"
done


\echo  " .. done. "
