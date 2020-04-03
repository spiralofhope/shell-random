#!/usr/bin/env  sh
# Repairs then unzips a broken .zip file

# Note that because this is a script and not a procedure the user will end up in the same directory they began in.  This does not act like unc()



if [ -z "$*" ]; then exit 1; fi


# test
# touch some_file ; zip some_zip.zip some_file ; rm -f some_file



# setup
temporary_file=$(      \tempfile  --directory ./  --prefix 'file_'  --suffix '.ziprepair.zip'  ||  exit $? )
temporary_directory=$( \tempfile  --directory ./  --prefix 'dir_'   --suffix '.ziprepair'      ||  exit $? )
\rm  --force  "$temporary_directory"  ||  exit  $?
\mkdir        "$temporary_directory"  ||  exit  $?



# go
\echo  'y'  |  \zip  --fixfix "$1"  --out "$temporary_file"
\cd     "$temporary_directory"  ||  exit  $?
\unzip  -o  ../"$temporary_file"
#  \unzip  -tqq  "$temporary_file"  >> /dev/null 2>&1



# teardown
\rm  --force  ../"$temporary_file"  ||  exit $?
