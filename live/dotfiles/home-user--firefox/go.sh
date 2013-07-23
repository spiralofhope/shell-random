#!/bin/sh

# FIXME - must not be run as root

date=$( \date +%Y-%m-%d--%H-%M-%S )
\echo  ""
\echo  " * Preparing home/user/.mozilla files and directories.."
\mkdir  --parents  ~/.mozilla

# Note that any open applications will probably fuck with this script.  Known problem-software:
#   - Firefox
#   - .. probably anything Mozilla


\echo  ""
\echo  " * Preparing home/user/.mozilla files.."
for i in *; do
  if [ ! -f $i ]; then
    continue
  fi
  # Back up any existing files.
  # If a file and not a symlink.
  if [ -f ~/.mozilla/$i -a ! -L ~/.mozilla/$i ]; then
    \mv  ~/.mozilla/$i  ~/.mozilla/${i}--$date
  fi
  \ln  --force  --no-target-directory  --symbolic  $PWD/$i  ~/.mozilla/$i
done



for i in *; do
  if [ ! -d $i ]; then
    continue
  fi
  # Back up any existing directories.
  # If a directory and not a symlink.
  if [ -d ~/.mozilla/$i -a ! -L ~/.mozilla/$i ]; then
    \mv  ~/.mozilla/$i  ~/.mozilla/${i}--$date
  else
    \ln  --force  --no-target-directory  --symbolic  $PWD/$i  ~/.mozilla/$i
  fi
done

\echo " .. done. "
