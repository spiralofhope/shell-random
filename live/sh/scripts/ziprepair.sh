#!/usr/bin/env  sh
# Repairs then unzips a broken .zip file
# shellcheck disable=2186
# mktemp does not support:
#   -  using the current directory
#   -  a prefix


# Note that because this is a script and not a procedure the user will end up in the same directory they began in.  This does not act like unc()



if  [   -z "$*" ] || \
    [ ! -f "$1" ]
then
  exit  1
fi



# testing:
# :> some_file ; zip some_zip.zip some_file ; rm -f some_file



# setup:
temporary_file=$(      \tempfile  --directory ./  --prefix 'file_'  --suffix '.ziprepair.zip'  ||  exit $? )
temporary_directory=$( \tempfile  --directory ./  --prefix 'dir_'   --suffix '.ziprepair'      ||  exit $? )
# `tempfile` does not support creating a temporary directory:
\rm  --force  "$temporary_directory"  ||  exit  $?
\mkdir        "$temporary_directory"  ||  exit  $?



# go:
\echo  'y'  |  \zip  --fixfix "$1"  --out "$temporary_file"
\cd     "$temporary_directory"  ||  exit  $?
\unzip  -o  ../"$temporary_file"
#  \unzip  -tqq  "$temporary_file"  >> /dev/null 2>&1



# teardown:
\rm  --force  ../"$temporary_file"  ||  exit $?
