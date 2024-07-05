#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  #\echo  'enter root password'
  \sudo  "$0"  $*
else



_teardown() {
  \veracrypt  --text  --dismount  "$encrypted_source_file"
  \rmdir   "$decrypted_target_mountpoint"  
  \umount  "$unencrypted_target_mountpoint"
  \rmdir   "$unencrypted_target_mountpoint"
}


_setup() {
  source_partition="$1"
  unencrypted_target_mountpoint="$2"
  encrypted_source_file="$3"


  if [ -z "$3" ]; then
    \echo  '* ERROR:  3 parameters expected:'
    \echo  "  $*"
    exit  1
  elif [ -z "$2" ]; then
    \echo  '* ERROR:  3 parameters expected:'
    \echo  "  $*"
    exit  1
  elif [ -z "$1" ]; then
    \echo  '* ERROR:  No parameters have been given:'
    \echo  "  $*"
    exit  1
  elif [ -z "$source_partition" ]; then
    \echo  '* ERROR:  Source partition does not exist:'
    \echo  "  $source_partition"
    exit  1
  fi


  source_partition="$( \realpath  --quiet  "$source_partition" )"
  decrypted_target_mountpoint="${unencrypted_target_mountpoint}_decrypted"
  encrypted_source_file="${unencrypted_target_mountpoint}${encrypted_source_file}"


  \echo
  \echo  "Mounting the partition:"
  \echo  "  $source_partition"
  \echo  "With the encrypted file:"
  \echo  "  $encrypted_source_file"
  \echo  "To the target directory:"
  \echo  "  $decrypted_target_mountpoint"
  \echo
  \mkdir  --parents            "$unencrypted_target_mountpoint"  ||  exit  $?
  \mount  "$source_partition"  "$unencrypted_target_mountpoint"  ;  _=$?
  case $_ in
    32)
      \echo  "* WARNING:  Already mounted there, trying to continue.."
      continue
    ;;
    *)
      exit  $_
    ;;
  esac
}


_go() {
  \mkdir  --parents  "$decrypted_target_mountpoint"  ||  exit  $?
  # veracrypt  --text  --keyfiles=''  --pim=0  --protect-hidden=no  --mount source.hc  /mnt/mnt
  \veracrypt  \
    --text  \
    --keyfiles=''  \
    --pim=0  \
    --protect-hidden=no  \
    --mount  "$encrypted_source_file"  "$decrypted_target_mountpoint"


  \echo
  \echo  'Press <enter> to teardown..'
  read  -r  __
}


_teardown  2>  /dev/null
_setup  $*
_go
_teardown


fi   # The above is run as root
