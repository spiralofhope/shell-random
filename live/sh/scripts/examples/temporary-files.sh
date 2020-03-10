#!/usr/bin/env  sh



#:<<'}'   #  Referencing the current process' PID ($$).
{
  # While $$ is easy to remember, this is not 100% guaranteed to be a unique filename.
  # It's also not appropriate when your script needs to refer to use several unique tempfiles.
  unique_file="/tmp/my_temporary_file.$$"
  \touch        "$unique_file"
  \ls           "$unique_file"
  \rm  --force  "$unique_file"
}


:<<'}'   #  Using  `mktemp`
{
  # GNU mktemp will create a file which is guaranteed to be unique.
  # By default it will use `/tmp` but you can specify another directory with the --tmpdir switch.
  unique_file=$( \mktemp )
  \ls           "$unique_file"
  \rm  --force  "$unique_file"
}


:<<'}'   #  Using  `mktemp`  in a more fancy way.
{
  # This method is especially useful for debugging multiple executions of the same script.
  # $$  is the process ID of the current process.
  # $PPID is the parent's process ID.
  # You can create a unique string to help identify/organize your tempfiles.
  unique_file=$( \mktemp  --suffix=".my_temporary_file.$$" )
  # example file:  /tmp/tmp.CjgG1vqFFC.my_temporary_file.17065
  \ls           "$unique_file"
  \rm  --force  "$unique_file"
}


:<<'}'   #  Using  `mktemp`  to note a reasonably-unique temporary filename.
         #  This cannot be guaranteed to be unique since something else could theoretically come along and happen to make a file with that exact name.
{
  # Consider using "local" if this is in a function.
  fairly_unique_variable_content=$( \mktemp  --dry-run )
  # example:  /tmp/tmp.oN1dvub6FE
  \echo  "$fairly_unique_variable_content"
}
