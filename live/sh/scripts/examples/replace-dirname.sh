#!/usr/bin/env  sh


# https://github.com/dylanaraps/pure-sh-bible#get-the-directory-name-of-a-file-path


# TODO - autotest.sh testing


# dirname ~/Pictures/Wallpapers/1.jpg
# =>
# /home/black/Pictures/Wallpapers/


# dirname ~/Pictures/Downloads/
# =>
# /home/black/Pictures/




dirname() {
  # Usage: dirname "path"

  # If '$1' is empty set 'dir' to '.', else '$1'.
  dir=${1:-.}

  # Strip all trailing forward-slashes '/' from the end of the string.
  #
  # "${dir##*[!/]}": Remove all non-forward-slashes from the start of the string, leaving us with only the trailing slashes.
  # "${dir%%"${}"}": Remove the result of the above substitution (a string of forward slashes) from the end of the original string.
  dir=${dir%%"${dir##*[!/]}"}

  # If the variable *does not* contain any forward slashes, set its value to '.'.
  [ "${dir##*/*}" ] && dir=.

  # Remove everything *after* the last forward-slash '/'.
  dir=${dir%/*}

  # Again, strip all trailing forward-slashes '/' from the end of the string (see above).
  dir=${dir%%"${dir##*[!/]}"}

  # Print the resulting string and if it is empty, print '/'.
  printf '%s\n' "${dir:-/}"
}



dirname  "$*"
