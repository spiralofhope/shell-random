#!/usr/bin/env  zsh
# Untested under sh/bash



# --
# -- Extract all the zip files in the current working directory.
# -- Put resulting files in a subdirectory.
# -- Pay special attention to check for corrupt archives.
# --


# FIXME - shouldn't I just test the zip files?
for i in *.zip; do
  \mkdir  --parents  ${i}_
#  \unzip  -t  $i
  \unzip  $i  -d  ${i}_
  if [ $? -ne 0 ]; then
    \echo  "ERROR"
    exit  $?
  fi
done | \leafpad
\echo  "rm  --force  *.zip  ;  rename  's/\.zip\_//' *"
