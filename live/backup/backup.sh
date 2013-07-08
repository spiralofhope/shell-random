#!/usr/bin/env  bash

# TODO URGENT -- what happens when given a nonexistent UUID/sdx/directory ?  This needs to be hardened.



# TODO - I need to hand-check that exclusion is working as expected.

# TODO - what was I thinking, separating this into a separate library?  Sigh, recombine and tidy up..

# TODO - echo_info 'some message'  , when looking for the backup exclude list, and have hardening here.. it has to exist because rsync does not fail gracefully.

# TODO - Redo backups to work another way.
#        I'm pondering processing a text file.
#        Or maybe I should just have the user summon this script like ./backup.sh source target and they can make their own little script for all their backup desires..


:<<'TESTED'
  # Tested and works.
  #_backup_go \
    #` # sda1 ` \
    #9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
    #` # sdb5 ` \
    #0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
    #` # `

  # Tested and works.
  #_backup_go \
    #/dev/sda1 \
    #/dev/sdb5 \
    #` # `

  # Tested and works.
  #_backup_go \
    #` # sda1 ` \
    #9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
    #/dev/sdb5 \
    #` # `

TESTED


# Tested 2013-07-02 on bash 4.2.45(1)-release (x86_64-pc-linux-gnu), on Lubuntu 13.04, updated recently.
# This is used very regularly, so expect it be updated.

# This requires GNU coreutils.
# echo
# ls
# tail
# mktemp
# basename
# readlink
# sync


:<<'IDEAS'
  - Generate a file tree.
  - Time the backups.

.. or arbitrarily use directories:

_backup_go \
  /some/directory \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  ` # `

.. if the target is a UUID, I could also provide a target directory within it.

_backup_go \
  <WHATEVER> \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1/some/directory \
  ` # `
IDEAS



_backup_go(){
  local  source=$1
  local  target=$2
  echo_info   ''  '----------------------------------------------------------------------'
  echo_info   ''  "$source => $target"

  # todo? - should this be configurable?
  working_directory=$( \mktemp  --directory  --suffix=.backup.$$  --tmpdir=/mnt )
  err  $?

  _smart_mount  $source  'ro'  'source'  ;  source=$__
  _smart_mount  $target  'rw'  'target'  ;  target=$__

  _backup_rsync  $source  $target

  # FIXME/todo - how can I check _backup_teardown for errors?
  _backup_teardown
}





if [ $(whoami) != "root" ]; then
  \echo  "ERROR:  You're not root!"  ;  exit 1
fi
# DASH - `source` is unavailable.
source  ./backup-lib.sh
_backup_die_int(){
  _backup_die  'control-c has been pressed.  Aborting!'
}
trap _backup_die_int INT
_backup_die(){
  if ! [[ -z $1 ]]; then
    echo_error  "$@"
  fi
  \echo  \ ${red}Aborting!${reset}
  _backup_teardown
  # FIXME - Leads to infinite loops.  Do I need another solution for this?
  #err  $?
  exit 1
}




# --
# -- CONFIGURATION
# --
# TODO:  Move self-specific stuff into a configuration file, and use that.  Make this more generic.
# For rsync to not actually write or delete files.
#dry_run=--dry-run
# Additional output, for troubleshooting.  I like to leave it on, just in case.
print_teardown_info='true'



_backup_one(){
  _backup_go \
    ` # sda1 ` \
    9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
    ` # sdb5 ` \
    0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
    ` # `

  _backup_go \
    ` # sda6 ` \
    6dcee7a7-f953-445a-98f0-35d3b06919fc \
    ` # sdb6 ` \
    a8690f5d-92ff-4319-bd1a-e519d06228a6 \
    ` # `
}
_backup_one



# NOTE - if doing recursive testing like this, don't forget to modify backup.rsync-exclude-list.txt with something like:
#   _TESTING/**
#   _TESTING2/**
# These tests seem to have gone ok.
_test_two() {
  local  testing_directory=/mnt/320-data/_TESTING
  \mkdir  --parents  $testing_directory
  _backup_go \
    ` # sda1 ` \
    9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
    $testing_directory \
    ` # `

  local  testing_directory=/mnt/320-data/_TESTING2
  \mkdir  --parents  $testing_directory
  _backup_go \
    ` # sda6 ` \
    6dcee7a7-f953-445a-98f0-35d3b06919fc \
    $testing_directory \
    ` # `
}
#_test_two



# TODO - this had issues before, but they should be sorted out now.  Re-test.
_backup_two(){
  local  backup_directory=/mnt/data2/NEW_BACKUPS-TODO

  _backup_go \
    ` # sda1 ` \
    9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
    $backup_directory/1-ssd-root \
    ` # `

  _backup_go \
    ` # sda6 ` \
    6dcee7a7-f953-445a-98f0-35d3b06919fc \
    $backup_directory/1-ssd-data \
    ` # `

  _backup_go \
    ` # sda6 ` \
    3ed573e8-1274-4faf-86a1-b929955c902b \
    $backup_directory/1-320-data \
    ` # `
}
#_backup_two



# TODO - this may introduce additional complexities.
_backup_three(){

  _backup_go \
    ` # sdc3 - /mnt/data1 ` \
    7174ce31-555c-40f4-a053-e433d16c4a80 \
    ` # TODO ` \
    TODO \
    ` # `

  _backup_go \
    ` # sdc4 - /mnt/data2 ` \
    84d22b45-b563-40ee-b7c7-be19887b74db \
    ` # TODO ` \
    TODO \
    ` # `

  _backup_go \
    ` # sdc1 - (root) ` \
    32021a44-58ac-49af-a900-b07b438487f6 \
    ` # TODO ` \
    TODO \
    ` # `
}
#_backup_three

exit 0
