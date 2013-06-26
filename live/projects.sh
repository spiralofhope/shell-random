#!/usr/bin/env zsh

PROJECTS="/l"
NEW_PROJECT_MESSAGE="New project notes started `date`"

if [ ! -d $PROJECTS ]; then
  \echo "ERROR:  \"${PROJECTS}\" does not exist!"
  return 1
fi
if [ ! -f "${PROJECTS}/projects.txt" ]; then
  \echo "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
  return 1
fi

\cd "$PROJECTS"

# Make sure it's the first tab.
# I only need to "&" (background process) for the first summoning of Geany.
\geany ./todo.txt &
# But I need to wait a bit so it actually gets a process which other files can attach to.
\sleep 1
\geany ./projects.txt

# Open all the other project files.
for i in *; do
  # This also works for symbolic links which point to a directory.
  if [ ! -d $i ]; then
    continue
  fi
  if [[ $i == 'lost+found' ]]; then
    continue
  fi
  echo " * Processing $i"
  if [ ! -f $i/$i.txt ]; then
    \echo "   New project, inserting message:\n   $NEW_PROJECT_MESSAGE"
    \echo "$NEW_PROJECT_MESSAGE" > $i/$i.txt
  fi
  \cat $i/$i.txt >> /dev/null
  \geany $i/$i.txt
  sleep 0.2
done

# Switch back to that first tab
\geany ./todo.txt &
