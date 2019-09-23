# Determine if something is a file, directory, symlink, etc.
# https://www.tldp.org/LDP/abs/html/fto.html


# TODO - elaborate with example code and working tests.



:<<'}'
{
!    "not" -- reverses the sense of the tests below
      Returns true if condition absent.


-d    file is a directory
-e    file exists
-f    file is a regular file (not a directory or device file)
-L    file is a symbolic link


-s    file is not zero size
-r    file has read permission (for the user running the test)
-w    file has write permission (for the user running the test)
-x    file has execute permission (for the user running the test)


-b    file is a block device
-p    file is a pipe
-S    file is a socket
-t    file (descriptor) is associated with a terminal device
        This test option may be used to check whether the stdin [ -t 0 ] or stdout [ -t 1 ] in a given script is a terminal.
-g    set-group-id (sgid) flag set on file or directory
        If a directory has the sgid flag set, then a file created within that directory belongs to the group that owns the directory, not necessarily to the group of the user who created the file. This may be useful for a directory shared by a workgroup.
-u    set-user-id (suid) flag set on file
        A file with the suid flag set shows an s in its permissions.
-k    sticky bit set
-O    you are owner of file
-G    group-id of file same as yours
-N    file modified since it was last read
f1 -nt f2    file f1 is newer than f2
f1 -ot f2    file f1 is older than f2
f1 -ef f2    files f1 and f2 are hard links to the same file


-c    file is a character device

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
