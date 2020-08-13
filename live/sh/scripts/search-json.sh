#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
  # I like backslashes.

# Read a JSON and get the contents of a specified key.


# TODO - allow a string to be passed
# FIXME - this will not work on complex things, like finding subtitles within the ytdl.sh's v.info.json file.



# For `autotest.sh`:
if [ $# -eq 0 ]; then
  unique_file="$( \mktemp )"
  #\echo  //ignore me  >  "$unique_file"
  #\echo  //{"one": "foo", "two": "bar"}  >  "$unique_file"
  #\echo  {"one": "content", "two": "12345678901"}  >  "$unique_file"
  #\echo  '{"one": "content", "two": "12345678901", "three": "a string, with a comma"}'  >  "$unique_file"
  \echo  '{"one": "content", "two": "12345678901", "three": "a string, with a comma", "four": "http://example.com"}'  >  "$unique_file"
  "$0"  'one'              "$unique_file"
  "$0"  'two'              "$unique_file"
  "$0"  'three'            "$unique_file"
  "$0"  'four'             "$unique_file"
  \rm  --force  --verbose  "$unique_file"
  return
fi



search_JSON() {
  [ $# -eq 2 ]  ||  return  1
  #
  key_to_search_for="$1"
  input_filename="$2"
  #
  [ -e "$input_filename" ]  ||  return 1
  #

  #result=$( \grep  --only-matching  --perl-regexp  '"fulltitle":.*?[^\\]",'  "$input_filename" )
  #length=$(( ${#result} - 2 ))
  #string-fetch-character-range.sh  15  $length  "$result"

  # I don't know if there is a better way to write this:
  # shellcheck disable=2002
  \cat  "$input_filename"  |\
    \tr  -d  '{}"'  |\
    \tr  ','  \\n  |\
    while  \read  -r  line; do
      # Skip over lines starting with '//' (comments):
      #   Note that comments are not officially supported by the JSON format, although individual libraries may support them.  As such, commented-JSON files ought to be run through a preparser like JSMin (which removes comments) before actually being used.
      [ "${line##//*}" ]  ||  continue
      key=$(   \echo "$line" | \cut  -d':' -f1 )
      # This was causing a bug for a value of 'http://example.com'
      #value=$( \echo "$line" | \cut  -d':' -f2 )
      value=$( \echo "$line" )
      #\echo  "$line"
      #\echo  "$key"
      #\echo  "$value"
      if [ "$key" = "$key_to_search_for" ]; then
        # Strip leading whitespace:
        value=${value#${value%%[![:space:]]*}}
        \echo  "$value"
        # Stop at the first match:
        return
      fi
    done  \
  ###
}
#
search_JSON  "$@"


# ----------
# Other ways
# ----------



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
