# TODO: Check for parameters
# TODO: Check that the parameter is a movie - by extension or by other means ("magic"?)
MYPWD="$PWD"
FILE=`"readlink" -f "$1"`
WORKING="/mnt/autofs/hdd/sdg1/p/"
COPY="$WORKING"/copy
NEW="$WORKING"/new

# Test setup
# \cp --force "./test.wmv-backup" "./test.wmv"

\cp --force "$FILE" "$COPY"
\avidemux2_gtk "$COPY"
\mv --force "$NEW" "$FILE"

\gmplayer "$1"

# Cleanup
# \rm --f "$COPY"
