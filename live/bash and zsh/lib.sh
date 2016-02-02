# Used by other functions.
# Loaded first, before everything.



# TODO - Fucking hell, `du` has trailing spaces and the name of the directory.  It even puts '.' if nothing is specified.
# TODO - remove a trailing period.
# TODO - remove trailing spaces.
comma() {
  if [ -z $1 ]; then
    # Incorrect usage.
    \echo  -n  ''
  elif [ -z $2 ]; then
    \echo "$1" | \sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'
  else
    # Incorrect usage.
    \echo  -n  ''
  fi
}
# Although at the commandline, this works:
#   comma 1000
# This is the required way to use it when scripting:
#   comma '1000'
# Or more complex:
#   count=$( comma $( \ls -1 . | \wc -l ) )
