#!/usr/bin/env bash

source testing.sh
source strings.sh

# TODO:  Separate the configuration into its own .ini file.

source='/1/compiled-website/source'
source_templates="${source}/templates"
target='/1/compiled-website/source'
# TODO:  Sanity-check the configuration

# TODO?  Put these in their own separate files?  Meh.
# Note:  Braces lets me code-fold these.
# Note:  I can disable parameter substitution by quoting the limit string:
#header=$(\cat <<'HEREDOC'
#example $1
#HEREDOC)
{
header=$(\cat <<HEREDOC
test header
HEREDOC)
}


{
footer=$(\cat <<HEREDOC
test footer\n
HEREDOC)
}


setup(){
  # Yes this could be smarter, but why bother.
  local verbosetouch() {
    \echo "created $1"
    \touch "$1"
  }
  # `touch` has no verbosity setting?!
  verbosetouch "$source"/test.asc
  \echo "some test content" >> "$source"/test.asc
  verbosetouch "$source"/test.fail
  \echo "--v"
}


teardown(){
  \echo "--^"
  \rm --force --verbose "$source"/test.asc
  \rm --force --verbose "$source"/test.fail
  \rm --force --verbose "$target"/test.html
}


go(){
  local compile(){
    # TODO:  Sanity-checking on $1
    target2=${target}/$( _filename_without_extension "$1" ).html
    \echo -n $header\\n$( \cat "$1" )\\n$footer > $target2
    \cat $target2
  }

  for i in "$source"/*; do
    if ! [ -f $i ] || [[ $( _extension "$i" ) != "asc" ]] ; then
      continue
    fi
    compile $i
  done
}


setup
go
teardown
