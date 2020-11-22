#!/usr/bin/env  sh


# https://github.com/dylanaraps/pure-sh-bible/blob/d683c3d4124a8327a744cf44f7df9744bec7fd36/README.md#print-unique-lines





if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  # Each of these words will be printed out on its own line and piped into _uniq()
  "$0"  "$( printf  '%s\n'  'foo bar baz qux foo' )"
  # =>
  # foo
  # bar
  # qux
  return
fi



_uniq() {
  # Store the current value of 'IFS' so we can restore it later.
  old_ifs=$IFS

  # Change the field separator to split on line endings (i.e. the newline character).
  IFS='
'

  # Ignore any arguments because we need the arguments list to be empty at first for string comparisons later on.
  set --

  # Read from standard input line by line.
  while IFS= read -r line; do
    # Consider the list (really a newline-delimited string) of all unique lines kept so far;
    case $IFS$*$IFS in
      # Is this line somewhere in that list?
      # If so, we know we have seen it before, so do nothing.
      *"$IFS$line$IFS"*) ;;

      # Otherwise, we know have not seen this line yet, so we append it to the arguments list as a new unique line.
      *) set -- "$@" "$line" ;;
    esac
  done

  # Print all the unique lines we kept.
  printf '%s\n' "$@"

  # Restore the value of 'IFS'.
  IFS=$old_ifs
}



:<<'}'   # For easy cut-and-paste
# taken from  `replace-uniq.sh`
_uniq() {
  old_ifs=$IFS
  IFS='
'
  set --
  while IFS= read -r line; do
    case $IFS$*$IFS in
      *"$IFS$line$IFS"*) ;;
      *) set -- "$@" "$line" ;;
    esac
  done
  printf '%s\n' "$@"
  IFS=$old_ifs
}


#echo $*
_uniq  "$( printf  '%s\n'  "$*" )"
#_uniq  "$*"

#echo $*
