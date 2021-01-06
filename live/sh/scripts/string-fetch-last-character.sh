#!/usr/bin/env  sh

# Return the last character from a string.
#
# This is a POSIXism for things like:
#   string='123'
#   printf  "$string"  |  \tail  --bytes=1
#     (I don't know why  \echo  or  \awk  don't work under zsh 5.7.1):
#     (I don't know why  printf  doesn't work):
#   echo  "$string"  |  awk  '{print substr($0,length,1)}'
#
# For Zsh, do:
#    string='123'
#     (I don't know why  \echo  or  printf  don't work under zsh 5.7.1):
#    echo  ${string: -1}
#
# For Bash, see:
#   https://stackoverflow.com/questions/17542892/



if [ -z "$*" ]; then
  # Pass example parameters to this very script:
  #"$0"  'testing'   # =>  g
  #"$0"  '1234'      # =>  4
  return
fi

string="$*"


string_fetch_last_character() {
  string_length=${#string}
  # Will be consumed during processing:
  string_last_character="$*"
  i=1
  until [ $i -eq "$string_length" ]; do
    #echo $i
    string_last_character="${string_last_character#?}"
    i=$(( i + 1 ))
  done

  printf  '%s'  "$string_last_character"
}
string_fetch_last_character  "$string"
