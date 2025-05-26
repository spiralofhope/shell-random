#!/usr/bin/env  sh
# Use variables from a configuration file.

:<<'}'
# This is useful for having one generic distributable script, allowing each user their own personalized configuration.

So, for example, if your script worked with usernames, it would not need it hard-coded in.
}



# This can be as simple as:
# . 'config-file.txt'

# Or more complicated, like:
# file called 'config-file.txt' in this directory.
# shellcheck disable=1090
. "$( \dirname "$( \realpath "$0" )" )"/config-file.txt



# It'll throw an error if the variable has not been set.
\echo  "${variable:?}"
