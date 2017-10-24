#!/usr/bin/env  sh



# TODO - De-reference symbolic links.  I think I have notes somewhere or other.


:<<'HEREDOC'
GNU coreutils
  http://www.gnu.org/software/coreutils/manual/coreutils.html
  'basename'
    http://www.gnu.org/software/coreutils/manual/coreutils.html#basename-invocation
    Alternate: 'cut' or with shell functionality.
  'dirname'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#dirname-invocation
    Alternate: 'cut' or with shell functionality.
  'realpath'
    https://www.gnu.org/software/coreutils/manual/coreutils.html#realpath-invocation
HEREDOC



\echo  ' * Working with a file:'


\echo
\echo  'This file:'
# e.g.:  ./examples/filenames.sh
\echo  "$0"
# This very script:
input="$0"


\echo
\echo  'Its expanded path:'
\echo  '  Note - This "fills out" things like ./dir/file.ext'
# e.g.:  /some/dir/filenames.sh
expanded_filename="$( \realpath "$input" )"
\echo  "$expanded_filename"


\echo
\echo  'Its directory without its file:'
# e.g.:  ./examples
directory_without_file="$( \dirname "$input" )"
\echo  "$directory_without_file"


\echo
\echo  'Its expanded directory path without its file:'
\echo  '  Note - This "fills out" things like ./dir'
# e.g.:  /some/dir'
\echo  '  Note - You might want to add a trailing slash yourself.'
expanded_directory_without_file="$( \dirname $( \realpath "$input" ) )"
\echo  "$expanded_directory_without_file"


\echo
\echo  'Its filename without its path:'
# e.g.:  filenames.sh
filename="$( \basename "$input" )"
\echo  "$filename"


\echo
\echo  'Its extension:'
# e.g.:  sh
extension="${input##*.}"
\echo  "$extension"


\echo
\echo  'Its filename without its path or extension:'
filename="$( \basename "$input" )"
filename_without_path_or_extension="${filename%.*}"
# e.g.:  filenames
\echo  "$filename_without_path_or_extension"



# ----------------------------------------------------------------------
\echo
\echo  '--'
\echo
\echo  ' * Working with directories:'
\echo  "   The following examples will use this very file's directory:"
directory_without_file="$( \dirname "$input" )"
example_directory="$directory_without_file"
# e.g.  ./some/dir
#       /path/to/some/dir
\echo  "$example_directory"

# These are simple examples, but being able to deal with more complex examples would require some heavier scripting:
#   - Count the number of subdirectories
#   - Show the second directory
#   - etc.


\echo
\echo  "It's expanded path is:"
\echo  '  Note - This "fills out" things like ./dir'
expanded_directory="$( \realpath "$example_directory" )"
# e.g. /path/to/some/dir
\echo  "$expanded_directory"


\echo
\echo  "It's last directory is:"
# e.g.:  dir
last_directory="$( \basename "$example_directory" )"
\echo  "$last_directory"


\echo
\echo  "It's second-last directory (not-expanded) is:"
# e.g.:  ./examples
second_last_directory="$( \dirname "$example_directory" )"
\echo  "$second_last_directory"


\echo
\echo  "It's second-last directory (expanded path) is:"
# e.g.:  ./examples
second_last_directory="$( \dirname "$example_directory" )"
second_last_directory_expanded="$( \realpath "$second_last_directory" )"
\echo  "$second_last_directory_expanded"


\echo
\echo  "It's second-last directory (name) is:"
# e.g. /path/to/some
second_last_directory="$( \dirname "$example_directory" )"
second_last_directory_expanded="$( \realpath "$second_last_directory" )"
second_last_directory_expanded_last="$( \basename "$second_last_directory_expanded" )"
\echo  "$second_last_directory_expanded_last"


\echo
