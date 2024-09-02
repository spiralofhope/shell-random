#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  #\echo  'enter root password'
  \sudo  "$0"  $*
else



source_encrypted_file="$1"
target_directory="$2"



# INT is ^C
trap _teardown INT
_teardown() {
  \veracrypt  --text  --dismount  "$source_encrypted_file"
}


_setup() {
  if   [ -z "$1" ]  \
  ||   [ -z "$2" ]; then
    \echo  '* ERROR:  2 parameters expected, got:'
    \echo  "  $*"
    exit  1
  elif [ ! -f "$source_encrypted_file" ]; then
    \echo  '* ERROR:  The source encrypted file does not exist:'
    \echo  "  $source_encrypted_file"
    exit  1
  elif [ ! -d "$target_directory" ]; then
    \echo  '* ERROR:  The target directory does not exist:'
    \echo  "  $target_directory"
    exit  1
  elif [ "$( \ls -A  $target_directory )" ]; then
    \echo  '* ERROR:  The target directory is not empty:'
    \echo  "  $target_directory"
    \echo  "*         Attempting to dismount."
    _teardown
#    exit  1
  fi

  # TODO - test if I can integrate it into the above as an elif
  if ( \mount | \grep  "$target_directory" ); then
    \echo  '* ERROR:  The target directory is already mounted:'
    \echo  "  $target_directory"
    exit  1
  fi
  
  
  \echo
  \echo  "Mounting the encrypted file:"
  \echo  "  $source_encrypted_file"
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
    --mount  "$source_encrypted_file"  "$target_directory"  \
  ||  _teardown


  \echo
  \echo  'Press <enter> to teardown..'
  read  -r  __  || _teardown
}


_teardown  2>  /dev/null
_setup  $*
_go
_teardown


fi   # The above is run as root
