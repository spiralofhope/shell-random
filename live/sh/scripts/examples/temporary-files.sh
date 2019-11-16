#!/usr/bin/env  sh



:<<'}'   #  Make a unique file in `/tmp`:
         #  Note - Don't forget to delete it after you're done with it.
{
  unique_file=$( \mktemp )
}


:<<'}'   #  Make a unique file in `/tmp` which is a little fancier:
{
  # $$  is the process ID of the current process.  I like to add this.
  # my_temporary_file could be some unique string so you can look at a collection of files in /tmp with something like /tmp/*.my_temporary_file.*
  unique_file=$( \mktemp  --suffix=".my_temporary_file.$$" )
  # example file:  /tmp/tmp.CjgG1vqFFC.my_temporary_file.17065
}


:<<'}'   #  Make a reasonably unique variable without touching the disk:
         #  This cannot be guaranteed to be unique since something else could theoretically come along and happen to make a file with that exact content or a variable with that exact content.
{
  local  fairly_unique_variable_content=$( \mktemp  --dry-run )
  \echo $fairly_unique_variable_content
}
