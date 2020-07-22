#!/usr/bin/env  zsh
# TODO: implement 'global' with find



:<<'}'
# or just do (zsh):
# For directories:  **/
# For files:  **
# This doesn't work..
global() {
  if [ -z "$1" ]; then return 0; fi
  for i in *; do
    \echo  "$i" > /dev/null
    "$@"
  done
}
:<<'}'   #  
global() {
  \echo  "use **"
}
:<<'}'   #  
globaldirs() {
  \echo  "use **/"
}
:<<'}'   #  
globaldirs() {
  # zshism
  # shellcheck disable=2124
  EXEC="$@"
  # zshism
  # shellcheck disable=2039
  # shellcheck disable=2206
  EXEC=(${=EXEC})
  # zshism
  # shellcheck disable=2128
  \echo  "$EXEC"
  for globaldirs in **/; do
    \cd  "$globaldirs" || return
    #\echo  "$EXEC"
    cd - || return
  done
}
