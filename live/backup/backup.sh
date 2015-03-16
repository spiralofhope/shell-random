#!/usr/bin/env  bash

# Exclude:
# _dotfiles/home-user--dotfiles/cache/
# firefox cache -- re-check that it's being excluded
# chromium cache
# midori cache
# links, lynx, any other browser..

# TODO URGENT -- what happens when given a nonexistent UUID/sdx/directory ?  This needs to be hardened.

# TODO - btrfs mount flags, with compression.  Compress everything btrfs, perhaps aggressively, since it's an unused backup.  If the source is different from the target - the source is not compressed, or is compressed differently, will rsync have a hard time of things?  It could be a horrible idea..
#        This would also have to be tested thoroughly, especially with the new i/o scheduling I've been playing with.

# If a btrfs filesystem was not mounted with compression enabled, it's possible to perform in-place compression to fix that.
# TODO - If files compressed with method a are re-compressed with method b is unknown.
#
#   \sudo  \mount  /dev/sdc3  /mnt/mnt  -o defaults,noatime,nodiratime,compress=lzo
#   \btrfs  filesystem  defragment  -clzo  -f  -r  /mnt/mnt
#
# TODO - What compression method this uses by default is unknown.
#   \btrfs  filesystem  defragment  -c     -f  -r  /mnt/mnt



:<<'TODO'
Switch from sfdisk to parted.

\sfdisk -n --print-id --quiet /dev/sdc 1

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util sfdisk doesn't support GPT. Use GNU Parted.

Use the --force flag to overrule this check.

(using --force does work)

----

\parted /dev/sdc1 print

Model: Unknown (unknown)
Disk /dev/sdc1: 10.0GB
Sector size (logical/physical): 512B/512B
Partition Table: loop

Number  Start  End     Size    File system  Flags
 1      0.00B  10.0GB  10.0GB  ext4

TODO


# TODO - I need to hand-check that exclusion is working as expected.

# TODO - what was I thinking, separating this into a separate library?  Sigh, recombine and tidy up..

# TODO - echo_info 'some message'  , when looking for the backup exclude list, and have hardening here.. it has to exist because rsync does not fail gracefully.

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




# TODO - sanity-checking on these inputs, now?
# TODO - Using parameters in this way is stupid.  I need to have --nofsck or the like, and allow them to be passed in arbitrary order.  As of this writnig, I don't know how I would implement that and I don't really want to use someone else's library.
if [[ $3 == nofsck ]]; then
  _skip_fsck=1
fi
_backup_go  "$1"  "$2"
