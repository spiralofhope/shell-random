#!/usr/bin/env  sh



DEBUG='true'



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  "$0"  2  'this is several words'
  # =>
  # words
  return
fi



DEBUG=${DEBUG='false'}
_debug() {
  if [ "$DEBUG" = 'true' ]; then
    \echo  "$*"  >&2
  fi
}



string_fetch_last_word() {
  string="$*"
  for word in $string; do
    # do nothing
    :
  done
  \echo  "$word"
}



string_fetch_last_word  "$@"
