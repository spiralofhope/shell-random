#!/usr/bin/env  sh
# Compare a CD to an ISO, to ensure it was burned properly.
# 2017-11-19 - This wasn't tested any time recently, and this may have bashisms.



:<<'NOTES'
* TODO - Use dialog, or have a file selection or a file auto-selection feature.

* TODO - Have a progress bar.  If this were wrapped up into something nice, I'd use bar:
  http://www.theiling.de/projects/bar.html

* TODO - Make it scan the directory
  **  If there is only one .iso file then use that.
  **  If there is no md5sum file, generate it from the ISO and create that file, and then use it
  
* How to burn Fedora DVDs to avoid readahead bug?
  **  https://www.redhat.com/archives/fedora-list/2007-May/msg01261.html
  
* Instead of using  `md5sum`  or  `dd`  , consider using  `cmp`  (maybe with --bytes= ) to avoid using a pipe and head.

* Check out  `isosize`  for checking the .iso structure without any padding.

* `dd`  might replace  `head`  if you use bs= and count=
  **  CDs normally have a blocksize of 2048, so the size ought to be a multiple of 2048; isosize can do division.  Untested:
        COUNT=`isosize -d 2048 $DEVICE`
        DISK_MD5=`dd if=$DEVICE bs=2048 count=$COUNT | md5sum`
      --  piping is a bad idea
      --  TODO - Learn the actual blocksize with  `isosize`
NOTES



# This could check for commandline parameters like this:
#   ISO_FILENAME=$1
#   MD5_FILENAME=$2
#   DEVICE=$3

ISO_FILENAME='pclinuxos-2007.iso'
MD5_FILENAME='pclinuxos-2007.md5sum'
DEVICE='/dev/dvd'

# If you don't have a .md5sum file, get the ISO's md5 with:
#   SOURCE_MD5=`md5sum $ISO_FILENAME`
read SOURCE_MD5 < "$MD5_FILENAME"
# Remove the trailing stuff and keep the md5sum
# FIXME? - Bashism?
SOURCE_MD5="${SOURCE_MD5%% *}"

FILESIZE=$( \stat -c%s "$ISO_FILENAME" )

# Get the disk's md5:
# This tests ok and should work for most computers:
# FIXME - just use  `dd`  ?
DISK_MD5=$( \md5sum "$DEVICE" )
# But some computers may instead need to use this command (tested and works):
#   DISK_MD5=`dd if=$DEVICE | head -c $FILESIZE | md5sum`
# There is also this (untested).  Where <device> is the scsi "scsibus,target,lun" and <filename> is the iso file.  Try "man readcd" for more info:
#   readcd dev=<device> f=- | diff -s - <filename>

# Remove the trailing stuff and keep the md5sum
# FIXME? - Bashism?
DISK_MD5="${SOURCE_MD5%% *}"

# Compare the two..
printf "\n\n\n"
if [ "$SOURCE_MD5" = "$DISK_MD5" ]; then
   echo "$ISO_FILENAME: OK"
else
   echo "Sorry, your disk is not ok"
   echo "I checked $ISO_FILENAME against $MD5_FILENAME"
   echo ""
   echo "md5sum was $SOURCE_MD5"
   echo "cd sum was $DISK_MD5"
fi
