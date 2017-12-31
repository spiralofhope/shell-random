#!/usr/bin/env  sh
# Used by other functions.
# Loaded before anything else "sh"-specific.
# Loaded before any zsh/bash content.



# --follow-name would allow the file to be edited and less will automatically display changes.
LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'
export  LESS



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
:<<'USAGE'
Although at the commandline, this works:
  comma 1000
This is the required way to use it when scripting:
  comma '1000'
Or more complex:
  count=$( comma $( \ls -1 . | \wc -l ) )
USAGE
