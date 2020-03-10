#!/usr/bin/env  sh



:<<'}'   #  Using $PPID
{
  # $PPID is the current process' current PID.
  # Therefore you could reference a quick-and-dirty tempfile referencing it.
  #temporary=/tmp/some_tempfile.$PPID
  # While easy to remember, this is not 100% guaranteed to be a unique filename.
  # It's also not appropriate when your script needs to refer to use several unique tempfiles.
}


#:<<'}'   #  Using  \mktemp
{
  tempfile=$( \mktemp  --suffix="_example" )
  \echo  " * Created example tempfile:  $tempfile"
  \ls  "$tempfile"
  # Don't forget to clean up after yourself.
  \rm  --force  --verbose  "$tempfile"
}
