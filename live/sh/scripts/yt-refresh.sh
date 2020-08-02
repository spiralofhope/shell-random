#!/usr/bin/env  sh

# Adjust the structure of a previous-generation of a cache.
# Update the description.
# Download the latest comments.


# Note that, although rare, you might get an error when downloading comments; check your scrollback buffer and re-try as needed.
# for i in *; do \cd "$i"; \echo "$PWD" ; yt-refresh.sh; cd - > /dev/null; done



# Check/truncate the directory length
fix_directory() {
  # Backup the name of the cache's directory, in case there's no proper info file cached.
  # Note that if the file already exists, there is no way to silence the warning:
  :>                     'original_directory.txt'
  \basename  "$PWD"  >>  'original_directory.txt'
  #
  directory_previous="$( \basename  "$PWD" )"
  #\echo  "$directory_previous"
  string_length_maximum=59
  string_to_append='…'
  string="$directory_previous"
  target_subdirectory=$( string-truncate-and-append.sh  "$string_length_maximum"  "$string_to_append"  "$string" )
  \cd  ../  ||  return  $?
  if [ ! "$directory_previous" = "$target_subdirectory" ]; then
    \mv  --verbose  "$directory_previous"  "$target_subdirectory"  ||  return  $?
    \cd  "$target_subdirectory"  ||  return  $?
  else
    \cd  "$directory_previous"  ||  return  $?
  fi
}



fix_description() {
  # Backup an old one if it's there.
  # .. but don't force it.
  \mv  --verbose  'v.description'  'v.description.old.txt'  2>  /dev/null
  #
  # Re-get v.description
  ytdld.sh
}



update_comments() {
  ytcs.sh
}



fix_directory
fix_description
update_comments
