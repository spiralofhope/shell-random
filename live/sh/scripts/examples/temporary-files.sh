#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
  # I like backslashes.

# The program `tempfile` usually also exists, but it is deprecated.  Note, however, that only `tempfile` has  --prefix



:<<'}'   #  Referencing the current process' PID ($$).
{
  # While $$ is easy to remember, this is not 100% guaranteed to be a unique filename.
  # It's also not appropriate when your script needs to refer to use several unique tempfiles.
  unique_file="/tmp/my_temporary_file.$$"
  # Make the file
  :>                       "$unique_file"
  \rm  --force  --verbose  "$unique_file"
}


:<<'}'   #  Using  `mktemp`
{
  # GNU mktemp will create a file which is guaranteed to be unique.
  # By default it will use `/tmp` but you can specify another directory with the --tmpdir switch.
  unique_file="$( \mktemp )"
  \rm  --force  --verbose  "$unique_file"
}


:<<'}'   #  Using  `mktemp`  in a more fancy way.
{
  # This method is especially useful for debugging multiple executions of the same script.
  # $$  is the process ID of the current process.
  # $PPID is the parent's process ID.
  # You can create a unique string to help identify/organize your tempfiles.
  unique_file="$( \mktemp  --suffix=".my_temporary_file.$$" )"
  # example file:  /tmp/tmp.CjgG1vqFFC.my_temporary_file.17065
  \rm  --force  --verbose  "$unique_file"
}


#:<<'}'   #  Using  `mktemp`  to note a reasonably-unique temporary variable content.
         #  This cannot be guaranteed to be unique since something else could theoretically come along and happen to make a file with that exact name.
{
  # Consider using "local" if this is in a function.
  fairly_unique_variable_content=$( \mktemp  --dry-run )
  # example:  /tmp/tmp.oN1dvub6FE
  \echo  "$fairly_unique_variable_content"
}
