#!/usr/bin/env  sh
# Adjust the modification and creation times of a directory.
# (Probably works on files too)



source_directory="source"
target_directory="target"
seconds_to_add="60"



modification_time_since_epoch="$( \stat -c %Y "$source_directory" )"
# Add 60 seconds (1 minute)
new_time="$((modification_time_since_epoch + "$seconds_to_add"))"
# Convert to touch-compatible format
new_time_str="$( \date -d "@$new_time" +%Y%m%d%H%M.%S )"
\touch  -t "$new_time_str"  "$target_directory"
\touch  -r "$source_directory"  -d "+1 minute"  "$target_directory"


# Confirm
\ls  -ld  "$source_directory"  "$target_directory"
