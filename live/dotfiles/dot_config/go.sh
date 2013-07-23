#!/bin/sh

# FIXME - must not be run as root

date=$( \date +%Y-%m-%d--%H-%M-%S )
\echo  ""
\echo  " * Preparing home/user/ dot files and directories.."
\mkdir  --parents  ~/.config

# Note that any open applications will probably fuck with this script.  Known problem-software:
#   - Chromium

for i in *; do
  if [ ! -d $i ]; then
    continue
  fi
  # Back up any existing directories.
  # If a directory and not a symlink.
  if [ -d ~/.config/$i -a ! -L ~/.config/$i ]; then
    \mv  ~/.config/$i  ~/.config/${i}--$date
  else
    \ln  --force  --no-target-directory  --symbolic  $PWD/$i  ~/.config/$i
  fi
done

\echo " .. done. "
