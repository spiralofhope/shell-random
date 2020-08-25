#!/usr/bin/env  sh
# shellcheck  disable=1001  disable=1012
#   I like using \ a lot.



# TODO - De-reference symbolic links.  I think I have notes somewhere or other.

# TODO - the path stuff are simple examples, but being able to deal with more complex examples would require some heavier scripting:
#   - Count the number of subdirectories
#   - etc.

# TODO - the first  directory:  e.g.  /path/to/directory  finds "path"
# TODO - the second directory:  e.g.  /path/to/directory  finds "to"



:<<'HEREDOC'
GNU coreutils
  http://www.gnu.org/software/coreutils/manual/coreutils.html
  'basename'
    http://www.gnu.org/software/coreutils/manual/coreutils.html#basename-invocation
    Alternate:  see `replace-basename.sh`
    Alternate:  `cut`
  'dirname'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#dirname-invocation
    Alternate:  see `replace-dirname.sh`
    Alternate:  `cut`
  'realpath'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#realpath-invocation
HEREDOC



# This very script:
example_filename="$0"
example_directory="$( \dirname  "$example_filename" )"



:<<'}'   #  The current script's path and filename
{
  \echo  "$0"
}



:<<'}'   #  A file's path and filename (expanded)
        # Note - This "fills out" things like ./dir/file.ext'
{
  \realpath  "$example_filename"
}



:<<'}'   #  A file's directory
{
  \dirname  "$example_filename"
}



:<<'}'   #  A file's directory (expanded)
        # Note - This "fills out" things like ./dir
        # Note - You might want to add a trailing slash yourself.
{
  \realpath  "$( \dirname  "$example_filename" )"
}



:<<'}'   #  A file without its path
{
  \basename  "$example_filename"
}



:<<'}'   #  A file's extension
{
  \echo  "${example_filename##*.}"
}



:<<'}'   #  A file's filename without its path or extension (1)
{
  filename="$( \basename  "$example_filename" )"
  filename_without_path_or_extension="${filename%.*}"
  \echo  "$filename_without_path_or_extension"
}



:<<'}'   #  A file's filename without its path or extension (2)
        # If you specify the extension directly (.sh in this case):
{
  \basename "$example_filename"  '.sh'
}



:<<'}'   #  A file's path
{
  \dirname  "$example_filename"
}



:<<'}'   #  A file's path (expanded)
        # Note - This "fills out" things like ./dir
{
  \realpath  "$( \dirname  "$example_directory" )"
}



:<<'}'   #  A file's directory
{
  \basename  "$( \realpath  "$example_directory" )"
}



:<<'}'   #  A file's second-to-last directory
        # Keep using "dirname" to walk further up the directory structure
{
  \basename  "$( \realpath  "$( \dirname  "$example_directory" )" )"
  # third-to-last
  #\basename  "$( \realpath  "$( \dirname  "$( \dirname  "$example_directory" )" )" )"
}
