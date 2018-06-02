#!/usr/bin/env  zsh
# TODO: implement 'global' with find



:<<'}'
# or just do (zsh):
# For directories:  **/
# For files:  **
# This doesn't work..
global() {
  if [ x$1 = x ]; then return 0; fi
  for i in *; do
    $@
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
  EXEC="$@"
  EXEC=(${=EXEC})
  \echo $EXEC
  for globaldirs in **/; do
    cd "$globaldirs"
    #\echo $EXEC
    cd -
  done
}
