#!/usr/bin/env  sh
# Display a dialog menu
# This is the "STDOUT 1" method, which uses a variable.



# Limited by the height of the terminal.
height=11
# Limited by the width of the terminal.
width=30
# The number of entries to be shown, before requiring scrolling.
# Limited by $height, above.
menu_height=4

# The menu is built with two columns.
# The left column is what is echoed
# The right column is an optional second column of textjust text
result=$( \dialog  --menu 'Example Menu'  "$height"  "$width"  "$menu_height" \
  '1' 'first' \
  '2' 'second' \
  '3' 'third' \
  '4' 'fourth' \
  --output-fd 1 )

if [ $? -ne 0 ]; then
  #\echo  "$? was returned"
  \echo  'Cancel was pressed'
  return $?
fi

case "$result" in
  1)
    # Place your code here.
    \echo  'one'
  ;;
  2)
    # Place your code here.
    \echo  'two'
  ;;
  3)
    # Place your code here.
    \echo  'three'
  ;;
  4)
    # Place your code here.
    \echo  'four'
  ;;
  *)
    \echo  'error'
  ;;
esac
