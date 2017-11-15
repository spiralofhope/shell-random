#!/usr/bin/env  sh
# Use variables from a configuration file.

:<<'}'
# This is useful for having one generic distributable script, allowing each user their own personalized configuration.

So, for example, if your script worked with usernames, it would not need it hard-coded in.
}



# This can be as simple as:
# . 'configuration_file.txt'

# Or more complicated, like:
# file called 'config-file' in this directory.
. "$( \dirname $( \realpath "$0" ) )"/config-file



\echo  "$variable"
