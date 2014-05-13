#!/usr/bin/env  zsh

# FIXME - this isn't working to start new projects for newly-created folders!

PROJECTS="/l"
NEW_PROJECT_MESSAGE="New project notes started `date`"

if [ ! -d $PROJECTS ]; then
  \echo  "ERROR:  \"${PROJECTS}\" does not exist!"
  return  1
fi
if [ ! -f "${PROJECTS}/projects.txt" ]; then
  \echo  "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
  return  1
fi

\cd  "$PROJECTS"

# Make sure it's the first tab.
# I only need to "&" (background process) for the first summoning of Geany.
\geany  "$PROJECTS"/todo.txt &
# But I need to wait a bit so it actually gets a process which other files can attach to.
\sleep  1
\geany  "$PROJECTS"/projects.txt

# Open all the other project files.
for i in *; do
  # This also works for symbolic links which point to a directory.
  if [ ! -d $i ]; then
    continue
  fi
  \echo  " * Processing $i"
  # If there is a file, and it is 0-byte, then don't open it!
  if [ ! -s "$i/$i.txt" ]; then
    \echo  "skipping $i"
    continue
  fi
  if [ ! -f $i/$i.txt ]; then
    \echo  "   New project, inserting message:\n   $NEW_PROJECT_MESSAGE"
    \echo  "$NEW_PROJECT_MESSAGE" > $i/$i.txt
  fi
  # ? Unsure.  Cache the file, in case Geany decides to be stupid?
  #\cat  $i/$i.txt >> /dev/null
  \geany  $i/$i.txt
  # I recall having issues where multiple instances of Geany would decide to pop up all over the place.  Sad.
  #\sleep  0.2
done

# Switch back to that first tab
\geany  "$PROJECTS"/todo.txt &
