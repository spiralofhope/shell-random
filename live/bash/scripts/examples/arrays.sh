#!/usr/bin/env  bash



# TODO - a lot more examples need to be made.  I've used arrays elsewhere, and that can be used as inspiration.



# Pass an array to a procedure:
testing() {
  for element in ${@}; do
    \echo  "$element"
  done
}
\echo
testing  string  'two words'  1
