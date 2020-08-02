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



fix_files() {
  \mv  *.annotations.xml  'v.annotations.xml'  2>  /dev/null
  \mv  *.description      'v.description'      2>  /dev/null
  \mv  *.info.json        'v.info.json'        2>  /dev/null
  \mv  *.jpg              'v.jpg'              2>  /dev/null
  \mv  *.mkv              'v.mkv'              2>  /dev/null
  \mv  *.mp4              'v.mp4'              2>  /dev/null

  if [ -f 'v_4.webp' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_*.jpg
  fi
  if [ -f 'v_3.jpg' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_0.jpg
    \rm  --force  v_1.jpg
    \rm  --force  v_2.jpg
  fi
  if [ -f 'v_4.jpg' ]; then
    _debug  ' * Deleting extraneous thumbnails.'
    \rm  --force  v_3.jpg
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
fix_files
fix_description
update_comments
