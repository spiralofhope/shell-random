#!/usr/bin/env  zsh
# Examples of iterating through a list / array (zsh-specific)
# zsh 5.0.7 (i586-pc-linux-gnu)
# Universal examples are found with sh/iteration.sh




:<<'}'  #  Iterate 1 to 3
{
  numa=0 ; numb=3
  until [ $numa -eq $numb ]; do
    ((numa++))
    echo $numa
  done
}


:<<'}'  #  Increment 1 to 10.
{
  for i in {1..10}; do echo $i; done
}


:<<'}'  #  Increment 1 to 10, with no line breaks.
{
  for i in {1..10}; do printf $i; done
}


# ---


local  array=(
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
  for i in ${array[@]}; do
    echo $i
  done
}



:<<'}'  #  Pass an array to a function, then iterate through it.
{
  example() {
    for element in ${@[@]}; do
      echo some text $element
    done
  }
  example  "my text" two 3
}



:<<'}'  #  Add items into an array.
{
  array=
  for i in {1..3}; do
    if [ -z "$array" ]; then
      array="$i x"
    else
      array="$array$IFS$i x"
    fi
  done
  # These all act the same:
  echo  '---'
  echo  $array
  echo  '---'
  echo  "$array"
  echo  '---'
  for i in $array; do
    echo $i
  done
  echo  '---'

  # Some setups may need to fiddle with IFS, but this is not necessary with my testing with zsh 5.7.1-1
  # IFS (Internal Field Separator), change to a carriage return:
  #IFS_original="$IFS"
  #IFS=$( printf "\r" )
  # (the script)
  # Reset:
  #IFS="$IFS_original"
  
  # This was an alternative one-liner which doesn't work with zsh 5.7.1-1
  # Technically I shouldn't be adding a \r to the beginning of the array, but it doesn't seem to matter.
  #array="$array$( printf "\r" )$i"
}
