#!/usr/bin/env  bash

# Tested 2013-07-02 on bash 4.2.45(1)-release (x86_64-pc-linux-gnu), on Lubuntu 13.04, updated recently.
# This is used very regularly, so expect it be updated.



:<<IDEAS
  - Generate a file tree.
  - Time the backups.

_backup_go \
  ` # sda1 ` \
  9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  ` # `

.. or arbitrarily use directories:

_backup_go \
  ` # sda1 ` \
  9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  /some/directory \
  ` # `

_backup_go \
  /some/directory \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  ` # `

.. where if the target is a UUID, I could also provide a target directory within it.

_backup_go \
  <WHATEVER> \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1/some/directory \
  ` # `


IDEAS

# TODO:  Move self-specific stuff into a configuration file, and use that.  Make this more generic.
working_directory=/mnt/_backup.$$


_backup_go(){
  local  source=$1
  local  target=$2
  echo_info   ''  "$source => $target"

  _smart_mount  $source  'ro'  ;  source=$__
  _smart_mount  $target  'rw'  ;  target=$__


_backup_die  '+++    dying here    +++'
}


if [ $(whoami) != "root" ]; then
  \echo  "ERROR:  You're not root!"  ;  exit 1
fi
# DASH - `source` is unavailable.
source  ./backup-lib.sh
# If the user does control-c
trap _backup_die_int INT
_backup_die_int(){
  \echo "^c"
  _backup_die
}
_backup_die(){
  if ! [[ -z $1 ]]; then
    echo_error  "$@"
  fi
  \echo \ ${red}Aborting!${reset}
  _backup_teardown
  err  $?
  exit 1
}

# TODO - this process will be redone to work another way, I'm pondering processing a text file.
# FIXME/TODO - hard-coded for now, until I solve the UUID => regular partition type problem.
#_backup_go \
  #/dev/sda1 \
  #/dev/sdb5 \
  #` # `

_backup_go \
  ` # sda1 ` \
  9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  /dev/sdb5 \
  ` # `


# TODO - this process will be redone to work another way, I'm pondering processing a text file.
# For now my testing and code are using UUIDs.
#_backup_go \
  #` # sda1 ` \
  #9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  #` # sdb5 ` \
  #0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  #` # `



exit 0
