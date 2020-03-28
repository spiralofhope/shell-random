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
# shellcheck disable=1090
. "$( \dirname "$( \realpath "$0" )" )"/config-file



# It'll throw an error if the variable has not been set.
\echo  "${variable:?}"
