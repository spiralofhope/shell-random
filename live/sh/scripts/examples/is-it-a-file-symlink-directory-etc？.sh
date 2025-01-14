#!/usr/bin/env  sh
# Determine if something is a file, directory, symlink, etc.
# https://www.tldp.org/LDP/abs/html/fto.html


# TODO - Create more example code and working tests.



:<<'}'
{
!    "not" -- reverses the sense of the tests below.
      For example, "[ ! -e ]" means "does not exist".


-e    exists
-d    is a directory
-f    is a regular file (not a directory or device file)
-L    is a symbolic link


-s    has a size (is not zero size / empty; note this does not understand sparse files)
-r    has read permission (for the user running the test)
-w    has write permission (for the user running the test)
-x    has execute permission (for the user running the test)


-b    is a block device
-c    is a character device
-p    is a pipe
-S    is a socket
-t    file (descriptor) is associated with a terminal device
        This test option may be used to check whether the stdin [ -t 0 ] or stdout [ -t 1 ] in a given script is a terminal.
-g    set-group-id (sgid) flag set on file or directory
        If a directory has the sgid flag set, then a file created within that directory belongs to the group that owns the directory, not necessarily to the group of the user who created the file. This may be useful for a directory shared by a workgroup.
-u    set-user-id (suid) flag set on file
        A file with the suid flag set shows an s in its permissions.
-k    has its sticky bit set
-O    you are its owner
-G    you have its group-id
-N    her been modified since it was last read
f1 -nt f2    "newer than" - file f1 is newer than f2
f1 -ot f2    "older than" - file f1 is older than f2
f1 -ef f2    "equal file" - files f1 and f2 are hard links to the same file
}



:<<'}'  #  Some examples
{
  device0="/dev/sda2"    # /   (root directory)
  if [ -b "$device0" ]
  then
    echo "$device0 is a block device."
  fi

  # /dev/sda2 is a block device.



  device1="/dev/ttyS1"   # PCMCIA modem card.
  if [ -c "$device1" ]
  then
    echo "$device1 is a character device."
  fi

  # /dev/ttyS1 is a character device.
}
