#!/bin/bash
# https://blog.spiralofhope.com/?p=2590



get_dependencies() {
  # I use  `apt-cache show`  instead of  `apt-cache depends`  because it's a single line, which is much easier to process.
  LIST=$( \
    \apt-cache  show \
    ` # The package to examine ` \
    $1 |\
    ` # Only show the dependencies.` \
    \grep Depends:\  |\
    ` # But remove that string.` \
    \sed 's/Depends:\ //' |\
    ` # Remove anything in brackets. ` \
    \sed 's/\((.*)\)//' |\
    ` # Remove whitespace ` \
    \sed 's/\ //g'
  )
}


process_list() {
  LIST=${LIST},
  while ! [[ $LIST == "" ]]; do
    # Get the first element
    __=${LIST%%\,*}
    # Remove the first element, and its trailing comma
    LIST=${LIST#*\,}
    # Do stuff.
    \echo $__
  done
}



get_dependencies  PROGRAM_NAME
process_list  $LIST

