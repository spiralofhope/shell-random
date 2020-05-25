#!/usr/bin/env  sh

# Read a JSON and get the contents of a specified key.
#   For example, if I had the following, I want to learn the value for "two" which is "bar"
#   {"one": "foo", "two": "bar"}


if [ -z "$*" ]; then
  # Some example content could be dumped into "example.json"
  #//ignore me
  #//{"one": "foo", "two": "bar"}
  #{"one": "content", "two": "12345678901"}
  "$0"  'two'  'example.json'
  return
fi


search_JSON() {
  key_search="$1"
  input_filename="$2"

  # I don't know if there is a better way to write this:
  # shellcheck disable=2002
  \cat  "$input_filename"  |\
    \tr -d '{}"'  |\
    \tr , \\n  |\
    while  \read  -r  line; do
      # Skip over lines starting with '//' (comments):
      #   Note that comments are not officially supported by the JSON format, although individual libraries may support them.  As such, commented-JSON files ought to be run through a preparser like JSMin before actually being used.
      [ "${line##//*}" ]  ||  continue
      key=$(   \echo "$line" | \cut  -d':' -f1 )
      value=$( \echo "$line" | \cut  -d':' -f2 )
      #\echo  "$line"
      #\echo  "$key"
      #\echo  "$value"
      if [ "$key" = "$key_search" ]; then
        # Strip leading whitespace:
        value=${value#${value%%[![:space:]]*}}
        printf  '%s\n'  "$value"
        # Stop at the first match:
        return
      fi
    done  \
  ###
}
#
search_JSON  "$1"  "$2"


:<<'}'   #  A decent one-liner
          #  FIXME - Outputs "0" for some reason
{
  \grep  --only-matching  --perl-regexp  '"'"id"'"\s*:\s*"\K([^"]*)'  "$input_filename"
}



:<<'}'   #  A confusing one-liner
          #  Gives too much and is generally confusing..
{
  \grep  --only-matching  --perl-regexp  '"id":.*?[^\\]",'  "$input_filename"
}
