#!/usr/bin/env zsh
# FIXME: This only works in zsh.  In regular shell (remove the top line) it's really truly fucked up!

# TODO - I don't need to use `find`
# FIXME:  Work in symbolic-link directories.

# TODO:  Skip lost+found

PROJECTS="/l/projects"
NEW_PROJECT_MESSAGE="New project notes started `date`"

if [ ! -f "${PROJECTS}/projects.txt" ]; then
  \echo "ERROR:  \"${PROJECTS}/projects.txt\" does not exist!"
  return 1
fi

\cd "$PROJECTS"

OLDIFS=$IFS
IFS=$'\n'

# TODO:  Find a way to make this code re-usable?

open_new_projects() {
  # TODO:  I have no clue how to go line-by-line in a variable, so I'm using `find` directly.  (update: I can use an array)
  # I'd bet that the IFS changing thing does the trick.
  for dir in $( \find . -maxdepth 1 -type d | \sort -f ); do
    # Remove the starting "." and then the starting "/"
    # This "blanks out" the current directory, which is normally just a period.
    dir=$( \echo "$dir" | \sed 's/^.//' | \sed 's/^\///' )
    ## Skip the blanked-out current directory
    if [ "x$dir" = "x" ]; then
      continue
    fi
    dir_file="${dir}/${dir}.txt"

    # The actual work
    if [ ! -f "$dir_file" ]; then
      \echo "Found a new project:  $dir"
      \echo "Inserting message:  $MESSAGE"
      \echo "$NEW_PROJECT_MESSAGE" > "$dir_file"
    fi
  done
}

cache_files() {
  # TODO:  I have no clue how to go line-by-line in a variable, so I'm using `find` directly.
  # I'd bet that the IFS changing thing does the trick.
  for dir in $( \find . -maxdepth 1 -type d | \sort -f ); do
    # Remove the starting "." and then the starting "/"
    # This "blanks out" the current directory, which is normally just a period.
    dir=$( \echo "$dir" | \sed 's/^.//' | \sed 's/^\///' )
    ## Skip the blanked-out current directory
    if [ "x$dir" = "x" ]; then
      continue
    fi
    dir_file="${dir}/${dir}.txt"

    # The actual work
    \cat "$dir_file" >> /dev/null
  done
}

open_files() {
  # TODO:  I have no clue how to go line-by-line in a variable, so I'm using `find` directly.
  # I'd bet that the IFS changing thing does the trick.
  for dir in $( \find . -maxdepth 1 -type d | \sort -f ); do
    # Remove the starting "." and then the starting "/"
    # This "blanks out" the current directory, which is normally just a period.
    dir=$( \echo "$dir" | \sed 's/^.//' | \sed 's/^\///' )
    ## Skip the blanked-out current directory
    if [ "x$dir" = "x" ]; then
      continue
    fi
    dir_file="${dir}/${dir}.txt"

    # The actual work
    \geany "$dir_file" &
    sleep 0.2
  done
}

# Make sure it's the first tab.
# I only need to "&" (background process) for the first summoning of Geany.
\geany ./todo.txt &
# But I need to wait a bit so it actually gets a process which other files can attach to.
\sleep 1
\geany ./projects.txt
open_new_projects
cache_files
open_files
\geany ./todo.txt

IFS=$OLDIFS
