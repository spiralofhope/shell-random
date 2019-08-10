#!/usr/bin/env  sh
# Run a program
# Where normally the script would launch it then continue
# Instead pause and wait for the program to exit before continuing
#
# 2019-08-09 on Debian 9.9.0-i386-xfce-CD-1


# Notice the trailing '&' :
\xclock &
\wait
# This is the alternative which would work on other systems:
#checkpid=$!
#\wait $checkpid &> /dev/null
\echo ' * Ended. '
