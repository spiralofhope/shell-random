#!/usr/bin/env  bash

# Tested 2013-07-02 on bash 4.2.45(1)-release (x86_64-pc-linux-gnu), on Lubuntu 13.04, updated recently.
# This is used very regularly, so expect it be updated.


# TODO - what was I thinking, separating this into a separate library?  Sigh, recombine and tidy up..



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



_backup_go(){
  local  source=$1
  local  target=$2
  echo_info   ''  '----------------------------------------------------------------------'
  echo_info   ''  "$source => $target"

  _smart_mount  $source  'ro'  'source'  ;  source=$__
  _smart_mount  $target  'rw'  'target'  ;  target=$__

  _backup_rsync  $source  $target

  # FIXME/todo - how can I check _backup_teardown for errors?
  _backup_teardown

#_backup_die  '+++    dying here    +++'
}





if [ $(whoami) != "root" ]; then
  \echo  "ERROR:  You're not root!"  ;  exit 1
fi
# DASH - `source` is unavailable.
source  ./backup-lib.sh
# If the user does control-c
_backup_die_int(){
  \echo "^c"
  _backup_die
}
trap _backup_die_int INT
_backup_die(){
  if ! [[ -z $1 ]]; then
    echo_error  "$@"
  fi
  \echo \ ${red}Aborting!${reset}
  _backup_teardown
  # FIXME - Leads to infinite loops.  Do I need another solution for this?
  #err  $?
  exit 1
}




# --
# -- CONFIGURATION
# --
# TODO:  Move self-specific stuff into a configuration file, and use that.  Make this more generic.
#working_directory=/mnt/_backup.$$
working_directory=$( \mktemp  --directory  --suffix=.backup.$$  --tmpdir=/mnt )
err  $?
# For rsync to not actually write or delete files.
#dry_run=--dry-run
# Additional output, for troubleshooting.  I like to leave it on, just in case.
print_teardown_info='true'



# TODO - Redo this to work another way.
#        I'm pondering processing a text file.
# Or maybe I should just have the user summon this script like ./backup.sh source target and they can make their own little script for all their backup desires..
_backup_go \
  ` # sda1 ` \
  9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  ` # `

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

# TODO - test source/target directory backups

# ---

_backup_go \
  ` # sda6 ` \
  6dcee7a7-f953-445a-98f0-35d3b06919fc \
  ` # sdb6 ` \
  a8690f5d-92ff-4319-bd1a-e519d06228a6 \
  ` # `



exit 0
