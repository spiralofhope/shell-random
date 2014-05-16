#!/usr/bin/env  sh



# sh - This will work well at the commandline.
# sh - In Openbox, opened as a hotkey, this will open multiple instances, with the bulk being in the last one opened.

# This will be erratic as all fuck with zsh.
# This will open two instances of random shit with bash.



setup() {
  PROJECTS="/l"
  NEW_PROJECT_MESSAGE="New project notes started `date`"
}



# Run before any other project text file is opened.
editor_setup() {
  # Make sure todo.txt is the first tab.
  \geany  "$PROJECTS"/todo.txt &
  # I need to make sure the geany process is running, otherwise another attempt to run geany may open a separate instance of it.
  # FIXME - is there a more graceful way to do this?  I just want to wait that a pid exists.
#  \sleep  1
  # Make sure projects.txt is the second tab.
  \geany  "$PROJECTS"/projects.txt &
}



# Run after all projects have been processed.
editor_finish() {
  # Switch back to the first tab.
  \geany  "$PROJECTS"/todo.txt &
}



editor_open_file() {
  \geany  "$1" &
}



process_projects() {
  if [ -d "$PROJECTS" ]; then
    # do nothing
    \echo  -n  ''
  else
    \echo  "ERROR:  \"${PROJECTS}\" does not exist!"
    return  1
  fi
  if [ -f "${PROJECTS}/projects.txt" ]; then
    # do nothing
    \echo  -n  ''
  else
    \echo  "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
    return  1
  fi

  \cd  "$PROJECTS"

  for i in *; do
    \echo  " * Processing $i"

    # This also works for symbolic links which point to a directory.
    # FIXME - clarify the above statement.
    if [ -d "$i" ]; then
      # do nothing
      \echo  -n  ''
    else
      \echo  "skipping non-directory $i"
      continue
    fi

    # If there is a file, and it is 0-byte, then don't open it.
    if [ -e "$i/$i.txt" ]; then
      local  size_of_file=$( \stat  --printf="%s"  "$i/$i.txt"  |  \cut -f 1 )
      if [ $size_of_file -eq 0 ] ; then
        \echo  "skipping 0-byte $i/$i.txt"
        continue
      fi
    fi

    if [ -f "$i/$i".txt ]; then
      # do nothing
      \echo  -n  ''
    else
      \echo  "   New project $i, inserting message:\n   $NEW_PROJECT_MESSAGE"
      \echo  "$NEW_PROJECT_MESSAGE" > "$i/$i.txt"
    fi
    editor_open_file  "$i/$i.txt"
  done
}



# --
# --  The actual work
# --

setup
editor_setup
process_projects
editor_finish
