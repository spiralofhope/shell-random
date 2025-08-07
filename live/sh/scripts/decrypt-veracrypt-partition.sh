#!/usr/bin/env  sh

# TODO - if the source partition is not mounted, then do so.  Steal from 16TB-A--decrypt.sh
# TODO - If the source partition is mounted, then bind it.
# TODO - determine if the source is actually an encrypted partition.  Then make this one universal script where I can specify (1)source partition + (2)file + (3)target partition, or just (1)encrypted source partition + (2)target partition.
# If I try to mount an encrypted partition, I get the following with an error code 32
#   mount: /mnt/mnt: unknown filesystem type 'crypto_LUKS'.
# Does Veracrypt throw a useful error code?  Does Veracrypt have a feature to check if a specified partition is encrypted?  Does some other tool have the ability to determine the type of partition? (perhaps fstab?):



# As root:
if ! [ "$USER" = 'root' ]; then
  #\echo  'enter root password'
  \sudo  "$0"  "$@"
else



_teardown() {
  \echo  _teardown code "$1"
  # TODO - fix the exit $? to also use the "return" trick
  \veracrypt  --text  --dismount  "$encrypted_source_partition"  ||  exit  $?
  # TODO - fix the exit $? to also use the "return" trick
  \rmdir  "$decrypted_target_mountpoint"  ||  exit  $?
  return 0  2> /dev/null || { exit 0; }
}



_setup() {
  encrypted_source_partition="$1"
  decrypted_target_mountpoint="$2"


  if [ -z "$2" ]; then
    \echo  '* ERROR:  2 parameters expected:'
    \echo  "  $*"
    return 1  2> /dev/null || { exit 1; }
  elif [ -z "$encrypted_source_partition" ]  \
  || ! [ -e "$encrypted_source_partition" ]; then
    \echo  '* ERROR:  Encrypted source partition does not exist:'
    \echo  "  $encrypted_source_partition"
    return 1  2> /dev/null || { exit 1; }
  fi


  encrypted_source_partition="$( \realpath  --quiet  "$encrypted_source_partition" )"


  \echo
  \echo  "Mounting the encrypted source partition:"
  \echo  "  $encrypted_source_partition"
  \echo  "To the target directory:"
  \echo  "  $decrypted_target_mountpoint"
  \echo
  # TODO - fix the exit $? to also use the "return" trick
  \mkdir  --parents  "$decrypted_target_mountpoint"  ||  exit  $?
}



_go() {
  \veracrypt  \
    --text  \
    --keyfiles=''  \
    --pim=0  \
    --protect-hidden=no  \
    --mount-options=system  \
    --mount  "$encrypted_source_partition"  "$decrypted_target_mountpoint"  \
  ||  _teardown  1


  \echo
  \echo  'Press <enter> to teardown..'
  read  -r  __  || _teardown  0
}


#_teardown  2>  /dev/null
_setup  $*
_go
_teardown  0


fi   # The above is run as root
