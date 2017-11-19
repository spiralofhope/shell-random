#!/usr/bin/env  sh
# Compare a CD to an ISO, to ensure it was burned properly.



:<<'IDEAS'
* TODO - Use dialog, or have a file selection or a file auto-selection feature.

* TODO - Have a progress bar.  If this were wrapped up into something nice, I'd use bar:
  http://www.theiling.de/projects/bar.html

* TODO - Make it scan the directory
  **  If there is only one .iso file then use that.
  **  If there is no md5sum file, generate it from the ISO and create that file, and then use it
IDEAS



# This could check for commandline parameters like this:
#   ISO_FILENAME=$1
#   MD5_FILENAME=$2
#   DEVICE=$3

ISO_FILENAME=pclinuxos-2007.iso
MD5_FILENAME=pclinuxos-2007.md5sum
DEVICE=/dev/dvd

# If you don't have a .md5sum file, get the ISO's md5 with:
#   SOURCE_MD5=`md5sum $ISO_FILENAME`
read SOURCE_MD5 < $MD5_FILENAME
# Remove the trailing stuff and keep the md5sum
SOURCE_MD5=${SOURCE_MD5%% *}

FILESIZE=$(stat -c%s "$ISO_FILENAME")

# Get the disk's md5:
# This tests ok and should work for most computers:
DISK_MD5=$( md5sum "$DEVICE" )
# But some computers may instead need to use this command (tested and works):
#   DISK_MD5=`dd if=$DEVICE | head -c $FILESIZE | md5sum`
# There is also this (untested).  Where <device> is the scsi "scsibus,target,lun" and <filename> is the iso file.  Try "man readcd" for more info:
#   readcd dev=<device> f=- | diff -s - <filename>

# Remove the trailing stuff and keep the md5sum
DISK_MD5=${SOURCE_MD5%% *}

# Compare the two..
printf "\n\n\n"
if [ $SOURCE_MD5 = $DISK_MD5 ]; then
   echo "$ISO_FILENAME: OK"
else
   echo "Sorry, your disk is not ok"
   echo "I checked $ISO_FILENAME against $MD5_FILENAME"
   echo ""
   echo "md5sum was $SOURCE_MD5"
   echo "cd sum was $DISK_MD5"
fi
