#!/bin/bash
# Download all of the listed dependencies of `apt-cache show`.
#
# https://blog.spiralofhope.com/?p=2590
#
# Tested 2013-06-08 on:
# Lubuntu 13.04
# bash 4.2.45(1)-release (x86_64-pc-linux-gnu)
# apt 0.9.7.7ubuntu4 for amd64 compiled on Apr 12 2013 23:49:01



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

