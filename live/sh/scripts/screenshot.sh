#!/usr/bin/env  sh
# screenshot helper
# Display a dialog menu for using scrot's different options.



# Limited by the height of the terminal.
height=11
# Limited by the width of the terminal.
width=40
# The number of entries to be shown, before requiring scrolling.
# Limited by $height, above.
menu_height=5

# The menu is built with two columns.
# The left column is what is echoed
# The right column is an optional second column of textjust text
result=$( \dialog  --menu 'Example Menu'  "$height"  "$width"  "$menu_height" \
  '1' 'full screen:  This display' \
  '2' 'select:  border on' \
  '3' 'select:  border off' \
  --output-fd 1 )

if [ $? -ne 0 ]; then
  #\echo  "$? was returned"
  \echo  'Cancel was pressed'
  return $?
fi

# --multidisp does not seem to matter.
case "$result" in
  1)
    one=
    two=
  ;;
  2)
    one='--select'
    two='--border'
  ;;
  3)
    one='--select'
    two=
  ;;
  *)
    \echo  'error'
  ;;
esac


\scrot  \
  'screenshot--%Y-%m-%d_%H:%M:%S--$wx$h.png' \
  "$one"  \
  "$two"  \
  --exec  '\
    \mv  $f   /l/__    ;\
    \gpicview /l/__/$f ;\
  '
