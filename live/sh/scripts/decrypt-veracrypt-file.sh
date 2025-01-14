#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  #\echo  'enter root password'
  \sudo  "$0"  "$@"
else



source_file_encrypted="$1"
target_directory="$2"



# INT is ^C
trap _teardown INT
_teardown() {
  if [ ! -z "$1" ]; then  \echo  "\n_teardown code '$1' for the script:\n  $0\n"; fi
  # Check if the file is decrypted
  \veracrypt  --list "$source_file_encrypted"  > /dev/null  2> /dev/null  \
  && (
    \veracrypt  --text  --dismount  "$source_file_encrypted"
  )
  return  2> /dev/null || { exit; }
}


_setup() {
  if   [ -z "$1" ]  \
  ||   [ -z "$2" ]; then
    \echo  '* ERROR:  2 parameters expected, got:'
    \echo  "  $*"
    return 1  2> /dev/null || { exit 1; }
  elif [ ! -e "$source_file_encrypted" ]; then
    \echo  '* ERROR:  The source encrypted file does not exist:'
    \echo  "  $source_file_encrypted"
    return 1  2> /dev/null || { exit 1; }
  elif [ ! -d "$target_directory" ]; then
    \echo  '* ERROR:  The target directory does not exist:'
    \echo  "  $target_directory"
    return 1  2> /dev/null || { exit 1; }
  elif [ "$( \ls -A  $target_directory )" ]; then
    \echo  '* ERROR:  The target directory is not empty:'
    \echo  "  $target_directory"
    # TODO - check if it's actually mounted:
      #source='/dev/sda1'
      #\mount | \cut  -d' '  -f1 | \grep  "^$source\$"
      #target='/'
      #\mount | \cut  -d' '  -f3 | \grep  "^$target\$"
    #\echo  "*         Attempting to dismount it."
    #\veracrypt  --text  --dismount  "$target_directory"
    #\umount  "$target_directory"
    return 1  2> /dev/null || { exit 1; }
  elif ( \mount | \grep  "$target_directory" ); then
    _teardown  "\n* ERROR:  The target directory is already mounted:\n$target_directory"
  fi
  
  
  \echo
  \echo  "Mounting the encrypted file:"
  \echo  "  $source_file_encrypted"
  \echo  "To the target directory:"
  \echo  "  $target_directory"
  \echo
}


_go() {
  # veracrypt  --text  --keyfiles=''  --pim=0  --protect-hidden=no  --mount source.hc  /mnt/mnt
  \veracrypt  \
    --text  \
    --keyfiles=''  \
    --pim=0  \
    --protect-hidden=no  \
    --mount  "$source_file_encrypted"  "$target_directory"  \
  ||  _teardown  "_go() - veracrypt mount:  $?"
  \echo
  \echo  'Press <enter> to teardown.'
  read  _  || _teardown
}



# Check if the file is already decrypted
\veracrypt  --list "$source_file_encrypted"  > /dev/null  2> /dev/null  \
&& (
  \echo  ' * That file is already decrypted:'
  \veracrypt  --list "$source_file_encrypted"
  \echo  'Do you want to dismount it from there to mount it to:'
  \echo  "$target_directory"
  \echo  'y to continue'
  \read _
  if [ "$_" = 'y' ]; then 
    \veracrypt  --text  --dismount  "$source_file_encrypted"
  else
    \echo  'You can manually encrypt / dismount it with:'
    \echo  "\\\veracrypt  --text  --dismount  \"$source_file_encrypted\""
    return 1  2> /dev/null || { exit 1; }
  fi
)
_setup  $*
_go
_teardown  'exit'


fi   # The above is run as root
