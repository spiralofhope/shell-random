#!/usr/bin/env  zsh



setup() {
  PROJECTS="/l"
  NEW_PROJECT_MESSAGE="New project notes started `date`"

  # Run before any other project text file is opened.
  editor_setup() {
    # Make sure it's the first tab.
    # I only need to "&" (background process) for the first summoning of Geany.
    \geany  "$PROJECTS"/todo.txt &
    # But I need to wait a bit so it actually gets a process which other files can attach to.
    \sleep  1
    \geany  "$PROJECTS"/projects.txt
  }

  # Run after all projects have been processed.
  editor_finish() {
    # Switch back to that first tab
    \geany  "$PROJECTS"/todo.txt &
  }

  editor_open_file() {
    # ? Unsure.  Cache the file, in case Geany decides to be stupid?
    #\cat  $1 >> /dev/null
    \geany  "$1"
    # I recall having issues where multiple instances of Geany would decide to pop up all over the place.  Sad.
    #\sleep  0.2
  }
}



process_projects() {
  if [ ! -d $PROJECTS ]; then
    \echo  "ERROR:  \"${PROJECTS}\" does not exist!"
    return  1
  fi
  if [ ! -f "${PROJECTS}/projects.txt" ]; then
    \echo  "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
    return  1
  fi

  \cd  "$PROJECTS"

  for i in *; do
    \echo  " * Processing $i"

    # This also works for symbolic links which point to a directory.
    # FIXME - clarify the above statement.
    if [ ! -d $i ]; then
      \echo  "skipping non-directory $i"
      continue
    fi

    # If there is a file, and it is 0-byte, then don't open it.
    if [[ -e "$i/$i.txt" ]]; then
      local  size_of_file=$( \stat  --printf="%s"  "$i/$i.txt"  |  \cut -f 1 )
      if [[ $size_of_file -eq 0 ]] ; then
        \echo  "skipping 0-byte $i/$i.txt"
        continue
      fi
    fi

    if [ ! -f $i/$i.txt ]; then
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
