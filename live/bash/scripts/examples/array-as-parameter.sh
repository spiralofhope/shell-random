#!/usr/bin/env  bash

# Pass an array into a function.
#   https://www.unix.com/shell-programming-and-scripting/61370-bash-ksh-passing-array-function.html
# Does not work with zsh, likely because of array-bashisms.  Unexplored.



print_array() {
  # Setting the shell's Internal Field Separator to null
  OLD_IFS="$IFS"
  IFS=''

  # Create a string containing "colors[*]"
  local  array_string="$1[*]"

  # assign loc_array value to ${colors[*]} using indirect variable reference
  local  loc_array=(${!array_string})

  # Resetting IFS to default
  IFS=$OLD_IFS

  # Checking the second element "Light Gray" (the one with a space)
  \echo  "${loc_array[1]}"
}

# create an array and display contents
colors=( 'Pink' 'Light Gray' 'Green' )
\echo  "colors:  ${colors[*]}"


#\echo  "The local array should not exist here: -->${loc_array[*]}<--"
# =>
# The local array should not exist here: --><--


# call function with positional parameter $1 set to array's name
print_array  colors
# =>
# Light Gray
