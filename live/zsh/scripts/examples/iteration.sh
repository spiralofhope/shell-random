#!/usr/bin/env  zsh
# Examples of iterating through a list / array (zsh-specific)
# zsh 5.0.7 (i586-pc-linux-gnu)
# Universal examples are found with sh/iteration.sh




:<<'}'  #  Iterate 1 to 3
# Note that vanilla dash iteration notes are in sh/scripts/examples/
{
  numa=0 ; numb=3
  until [ "$numa" -eq "$numb" ]; do
    # zshism
    # shellcheck disable=2039
    ((numa++))
    \echo  "$numa"
  done
}


:<<'}'  #  Increment 1 to 10.
{
  # zshism
  # shellcheck disable=2039
  for i in {1..10}; do \echo  "$i"; done
}


:<<'}'  #  Increment 1 to 10, with no line breaks.
{
  # zshism
  # shellcheck disable=2039
  for i in {1..10}; do \printf '%s'  "$i"; done
}


# ---


# zshism
# shellcheck disable=2039
array=(
  string
  "one quoted string"
  separated words
  1
)
# This is the same:
#array=( string "two words" 1 )


# Count the number of items in an array:
#echo  ${#array[@]}
#  =>  3
# You can also count the number of arguments passed to a script:
#echo  ${#*[@]}



:<<'}'  #  Iterate by line, ignoring beginning spaces.
{
  # zshism
  # shellcheck disable=2039
  # shellcheck disable=2068
  for i in ${array[@]}; do
    \echo  "$i"
  done
}



:<<'}'  #  Pass an array to a function, then iterate through it.
{
  example() {
    # zshism
    # shellcheck disable=2068
    for element in ${@[@]}; do
      \echo  "some text $element"
    done
  }
  example  "my text" two 3
}



:<<'}'  #  Add items into an array.
{
  # zshism
  # shellcheck disable=2178
  array=
  # zshism
  # shellcheck disable=2039
  for i in {1..3}; do
    # zshism
    # shellcheck disable=2128
    if [ -z "$array" ]; then
      # zshism
      # shellcheck disable=2178
      array="$i x"
    else
      # zshism
      # shellcheck disable=2128
      # shellcheck disable=2178
      array="$array$IFS$i x"
    fi
  done
  # These all act the same:
  \echo  '---'
  # zshism
  # shellcheck disable=2086
  # shellcheck disable=2128
  \echo  $array
  \echo  '---'
  # zshism
  # shellcheck disable=2128
  \echo  "$array"
  \echo  '---'
  # zshism
  # shellcheck disable=2128
  for i in $array; do
    \echo  "$i"
  done
  \echo  '---'

  # Some setups may need to fiddle with IFS, but this is not necessary with my testing with zsh 5.7.1-1
  # IFS (Internal Field Separator), change to a carriage return:
  #IFS_original="$IFS"
  #IFS=$( \printf  '\r' )
  # (the script)
  # Reset:
  #IFS="$IFS_original"
  
  # This was an alternative one-liner which doesn't work with zsh 5.7.1-1
  # Technically I shouldn't be adding a \r to the beginning of the array, but it doesn't seem to matter.
  #array="$array$( \printf  '\r' )$i"
}
