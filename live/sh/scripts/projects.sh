#!/usr/bin/env  sh



# Goal
# Given a series of directories.
# Open a text file located within each directory.
# Prefer loading some files first, so they will appear as the first tabs.



# FIXME - If run multiple times, it will attempt to open a new tab with a nonexistent file.
#         This is likely because I have a leading or trailing printf in the final command.



setup() {
  \echo  " * begin"
  projects_directory="/l"
  windows_projects_directory="/mnt/1/windows-data/l/live"
  NEW_PROJECT_MESSAGE="New project notes started `date`"
  \cd  "$projects_directory"
  # Case-insensitivity.
  LC_COLLATE=en_US ; export LC_COLLATE
  # IFS (Internal Field Separator), change to a carriage return.
  IFS_original=$IFS
  IFS=`printf "\r"`
}


build_array_of_directories() {
  for i in *; do
    # Skip non-directories
    # Note that this will not skip symlinks.
    if ! [[ -d "$i" ]]; then
      \echo  "skipping non-directory  $i"
      continue
    fi
    #\echo  "processing - $i"
    # I don't know why this won't work:
    #array_of_directories="$array_of_directories$IFS$i"
    # Technically I shouldn't be adding a \r to the beginning of the array, but it doesn't seem to matter.
    array_of_directories="$array_of_directories`printf \"\r\"`$i"
  done
  #\echo  "$array_of_directories"

  #for i in $array_of_directories; do
    #echo ++$i
  #done
  #return 0
}


build_array_of_files() {
  for i in $array_of_directories; do
    if [[ $i == "" ]]; then continue; fi
    i="$i/$i.txt"

    # Create files as necessary
    # TODO? - Skip files in an array of exclusions
    # TODO - check if this will work properly with symlinks.
    if ! [[ -f "$i" ]]; then
      \echo .
      \echo  "   New project $i, inserting message:"
      \echo  "$NEW_PROJECT_MESSAGE"
      \echo .
      \touch  "$i"
      \echo  "$NEW_PROJECT_MESSAGE" >> "$i"
    fi
    local  size_of_file=` \stat  --printf="%s"  "$i"  |  \cut -f 1 `
    if [[ $size_of_file == 0 ]] ; then
      \echo  "skipping 0-byte $i"
      continue
    fi
    #\echo  "processing - $i"
    array_of_files="$array_of_files`printf \"\r\"`$i"
  done
  #\echo  $array_of_files

  #for i in $array_of_files; do
    #echo ++$i
  #done
  #return 0
}


process_array_of_files() {
  # Ensure these are the first tabs:
  # TODO? - Yes this could be made cleaner, but at this point I don't give a fuck.
  array_of_files="todo.txt`printf \"\r\"`projects.txt`printf \"\r\"`_outbox--0/_outbox--0.txt`printf \"\r\"`$windows_projects_directory/_outbox--0/_outbox--0.txt`printf \"\r\"`$windows_projects_directory/_outbox--1/_outbox--1.txt`printf \"\r\"`$array_of_files"

  # Switch to the first tab:
  array_of_files="$array_of_files`printf \"\r\"`todo.txt"
}


open_array_of_files() {
  #echo  \geany  $array_of_files
  \geany  $array_of_files
}



teardown() {
  IFS=$IFS_original
  \echo  " * end"
}



# --
# --  The actual work
# --

setup
build_array_of_directories
build_array_of_files
process_array_of_files
open_array_of_files
teardown
