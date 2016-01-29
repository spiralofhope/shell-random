#!/usr/bin/env  sh



# sh   - This will work well at the commandline.
# sh   - In Openbox, opened as a hotkey, this will open multiple instances, with the bulk being in the last one opened.
# zsh  - This will be erratic as all fuck.
# bash - This will open two instances of random shit.



setup() {
  PROJECTS="/l"
  NEW_PROJECT_MESSAGE="New project notes started `date`"
}



cache_file() {
  \cat  "$1"  > /dev/null
}



# Run before any other project text file is opened.
editor_setup() {
  cache_file  "$PROJECTS"/todo.txt
  cache_file  "$PROJECTS"/projects.txt
  cache_file  /1/_outbox--0/_outbox--0.txt
  cache_file  /mnt/1/windows-data/l/live/_outbox--0/_outbox--0.txt
  cache_file  /mnt/1/windows-data/l/live/_outbox--1/_outbox--1.txt

  # Make sure todo.txt is the first tab.
  \geany  "$PROJECTS"/todo.txt &
  # I need to make sure the geany process is running, otherwise another attempt to run geany may open a separate instance of it.
  # FIXME - is there a more graceful way to do this?  I just want to wait that a pid exists.
  \sleep  1
  # Make sure projects.txt is the second tab.
  \geany  "$PROJECTS"/projects.txt
  \geany  /1/_outbox--0/_outbox--0.txt
  \geany  /mnt/1/windows-data/l/live/_outbox--0/_outbox--0.txt
  \geany  /mnt/1/windows-data/l/live/_outbox--1/_outbox--1.txt
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
  if [ ! -d "$PROJECTS" ]; then
    \echo  "ERROR:  \"${PROJECTS}\" does not exist!"
    return  1
  fi
  if [ ! -f "${PROJECTS}/projects.txt" ]; then
    \echo  "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
    return  1
  fi

  \cd  "$PROJECTS"

  for i in *; do
    if   [ ! -d "$i" ]; then
      continue
    elif [ ! -f "$i/$i".txt ]; then
      cache_file  "$1"
    fi
  done

  for i in *; do
    \echo  " * Processing $i"

    # This also works for symbolic links which point to a directory.
    # FIXME - clarify the above statement.
    if [ ! -d "$i" ]; then
      \echo  "skipping non-directory $i"
      continue
    # TODO - design some other way to skip directories without needing a file in that directory.
    elif [ "$i" = "e" ] || [ "$i" = "e_p" ]  ; then
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

    if [ ! -f "$i/$i".txt ]; then
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
