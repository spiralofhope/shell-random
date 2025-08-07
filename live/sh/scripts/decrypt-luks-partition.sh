#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  #\echo  'enter root password'
  \sudo  "$0"  "$@"
else



_teardown() {
  \umount  "$decrypted_target_mountpoint"
  \rmdir   "$decrypted_target_mountpoint"


  # Also:  cryptsetup  luksClose
  \cryptsetup  close  /dev/mapper/"$luks_mapper"

  return 0  2> /dev/null || { exit 0; }
}



_setup() {
  encrypted_source_partition="$1"
  luks_mapper="$2"
  decrypted_target_mountpoint="$3"


  if [ -z "$3" ]; then
    \echo  '* ERROR:  3 parameters expected:'
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
  # Also:  cryptsetup  luksOpen

  \cryptsetup  open  \
    "$encrypted_source_partition"  \
    "$luks_mapper" \
  ||  _teardown  1

  \echo  "/dev/mapper/${luks_mapper}"
  \echo  '  =>'
  \echo  "$decrypted_target_mountpoint"

  \mount  /dev/mapper/"$luks_mapper"  "$decrypted_target_mountpoint"


  \echo
  \echo  'Press <enter> to teardown..'
  read  -r  __  || _teardown  0
}


#_teardown  2>  /dev/null
_setup  $*
_go
_teardown  0


fi   # The above is run as root
