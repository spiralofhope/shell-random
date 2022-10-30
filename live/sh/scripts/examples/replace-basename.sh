#!/usr/bin/env  sh


# https://github.com/dylanaraps/pure-sh-bible#get-the-base-name-of-a-file-path


# TODO - autotest.sh testing


# basename ~/Pictures/Wallpapers/1.jpg
# =>
# 1.jpg

# basename ~/Pictures/Wallpapers/1.jpg .jpg
# =>
# 1

# basename ~/Pictures/Downloads/
# =>
# Downloads



_basename() {
  # Usage: basename "path" ["suffix"]

  # Strip all trailing forward-slashes '/' from the end of the string.
  #
  # "${1##*[!/]}": Remove all non-forward-slashes from the start of the string, leaving us with only the trailing slashes.
  # "${1%%"${}"}:  Remove the result of the above substitution (a string of forward slashes) from the end of the original string.
  dir=${1%${1##*[!/]}}

  # Remove everything before the final forward-slash '/'.
  dir=${dir##*/}

  # If a suffix was passed to the function, remove it from the end of the resulting string.
  dir=${dir%"$2"}

  # Print the resulting string and if it is empty, print '/'.
  printf '%s\n' "${dir:-/}"
}



# For easy copy-paste:
:<<'}'   #  Taken from  `replace-basename.sh`
_basename() {
  dir=${1%${1##*[!/]}}
  dir=${dir##*/}
  dir=${dir%"$2"}
  printf '%s\n' "${dir:-/}"
}



_basename  "$*"
