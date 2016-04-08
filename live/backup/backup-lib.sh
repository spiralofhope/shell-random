#!/usr/bin/env  sh



source  ./backup-configuration.sh


# When mounting read-write, mount with risky performance options.
#   - Anything I mount for writing will be more-or-less exclusively mounted by this script.
#   - Writing is only being done to a location where its contents don't matter so much.
# Problem 1 - I need to research and properly understand such options.
# Problem 2 - The options are different per filesystem.
#             So I could have partition type 83, ext4 or btrfs, which have different mount options.
#partition_type_83_mount_options=nouser,noatime,nodiratime,data=writeback,barrier=0,nobh
# nobarrier exists, but they give a healthy warning.
#partition_type_83_mount_options=nouser,noatime,nobh
# This seems universal.
# Actually, btrfs didn't list nouser as of 2013-07-05.  But I see mentions of it elsewhere.
#   https://btrfs.wiki.kernel.org/index.php/Mount_options
partition_type_83_mount_options=nouser,noatime,nodiratime
# compress=lzo is for btrfs
#partition_type_83_mount_options=nouser,noatime,nodiratime,compress=lzo
partition_type_7_mount_options=noatime,nodiratime
# `mount -s`  for sloppy mounting which ignores unsupported options does not solve this problem.
# One idea is to use  `parted`  .. there is  `parted --list --script`  but it's really truly awfully messy.  Is there an easier way to get information on a particular partition?  The man page is useless, as expected with GNU software.


# Taken from zsh/colors.sh
# Expect that version there to have more functionality.
_initializeANSI() {
  esc=""

  black="${esc}[30m"
  red="${esc}[31m"
  green="${esc}[32m"
  yellow="${esc}[33m"
  blue="${esc}[34m"
  purple="${esc}[35m"
  cyan="${esc}[36m"
  white="${esc}[37m"
  gray="${boldoff}${esc}[37m"
  grey="${boldoff}${esc}[37m"

  blackb="${esc}[40m"
  redb="${esc}[41m"
  greenb="${esc}[42m"
  yellowb="${esc}[43m"
  blueb="${esc}[44m"
  purpleb="${esc}[45m"
  cyanb="${esc}[46m"
  whiteb="${esc}[47m"

  boldon="${esc}[1m"
  boldoff="${esc}[22m"
  italicson="${esc}[3m"
  italicsoff="${esc}[23m"
  ulon="${esc}[4m"
  uloff="${esc}[24m"
  invon="${esc}[7m"
  invoff="${esc}[27m"

  black_bold="${boldon}${esc}[30m"
  red_bold="${boldon}${esc}[31m"
  green_bold="${boldon}${esc}[32m"
  yellow_bold="${boldon}${esc}[33m"
  blue_bold="${boldon}${esc}[34m"
  purple_bold="${boldon}${esc}[35m"
  cyan_bold="${boldon}${esc}[36m"
  white_bold="${boldon}${esc}[37m"

  reset="${esc}[0m"

  cursor_position_save="\033[s"
  cursor_position_restore="\033[u"
}
_initializeANSI



echo_error(){
  \echo \ ${red}error${reset} - $1${yellow}$2${reset}$3
}



#echo_ok(){
  #\echo \ ${green}ok${reset} - $1:  ${yellow}$2 ${reset}
#}



# FIXME - I don't know how to do something like $3*
echo_info(){
  \echo  \ ${yellow}info${reset} \ - $1${yellow}$2${reset}$3$4$5$6$7$8$9
}



err() {
  if [ "x$1" = "x0" ]; then
    return  $1
  fi
  if [ x$rsync = x1 ]; then
    # If I've just been running `rsync`
    if [ x$1 = x24 ]; then
      \echo  -e "${bullet} $processing - $processing - Rsync exited with code 24.  No problem."
      return  $1
    fi
    if [ x$1 = x23 ]; then
      \echo  -e "${bullet} $processing - Rsync exited with code 23.  No problem."
      return  $1
    fi
  fi

  _backup_die  'ERROR:  Non-zero exit code '  "$1"  ' received, aborting!'
  # Note that this command won't be found if this script doesn't get far enough into its routine..
}


# This assumes  /dev/sdx  format.
_check_if_sdx_is_mounted(){
  # fixme - This isn't really the way to go.
  #         Perhaps I could:  `\cat  /proc/self/mounts`  but does that pose portability concerns?
  #\mount  |  \cut  -d' '  -f1  |  \grep  --quiet  "$1"
  \echo  -n  $( \mount  |  \cut  -d' '  -f1  |  \grep  "$1" )" " | grep --quiet "$1"\ 
  # not mounted:  1
  #     mounted:  0
  return $?
}



# This assumes  /dev/sdx  format.
# note that  `\mountpoint`  does the reverse of this.  Given  /  it'll say something like  /dev/sda1
_find_mount_point(){
  _check_if_sdx_is_mounted  $1
  if [ $? -ne 0 ]; then
    _backup_die  "_find_mount_point() is being used on something that's not actually mounted: "  $1
  fi
  __=$( \mount  |  \grep  $1" "  |  \cut  -d' '  -f3  )
}



# This assumes  /dev/sdx  format.
_fsck_if_not_mounted() {
  _check_if_sdx_is_mounted  $1
  if [[ $_skip_fsck -eq 1 ]]; then
    echo_info  "$1 is "  'not being fscked'  ', skipping fsck.'
  elif [[ $? -eq 1 ]]; then
    echo_info  "$1 is "  'not mounted'  ', performing fsck.'
    \fsck  $1
    __=$?
    if [[ $__ -eq 8 ]]; then
      if [[ $ignore_fsck_error_8 = 'true' ]]; then
        echo_info  'fsck gave error ' 8 ', perhaps you need to install btrfs-tools or another similar package.'
        echo_info  '$ignore_fsck_error_8 has been set to ' true ', continuing.'
        __=0
      else
        _backup_die  'fsck gave error ' 8 ', perhaps you need to install btrfs-tools or another similar package.'
      fi
    fi
    err  $__
  else
    echo_info  "$1 is "  'mounted'  ', skipping fsck.'
  fi
}



# TODO - it's ok to depend on coreutils!
# TODO - It would be nice to have a  readlink  replacement for bash, but that seems horribly complicated.  Why in the fuck isn't it just an option with  `ls`  ?  Oh right, it's GNU.
#   filename -> ../../sda1            =>   ../../sda1
# Even if the filename is stupid, it works.
#   file -> name -> ../../sda1        =>   ../../sda1
_readlink_lazily(){
  __=$( \ls  -l  "$1" )
  err  $?
  __=${__##* -> }
}



# TODO - it's ok to depend on coreutils!
# yields the part after the last slash.
# http://mintaka.sdsu.edu/GF/bibliog/latex/debian/bash.html
_basename(){
  __=${1##*/}
}



# extracts the part of the path variable before the last slash
# http://mintaka.sdsu.edu/GF/bibliog/latex/debian/bash.html
# Unused, and left here for reference.
#_dirname(){
  #__=${1%/*}
#}


_distinguish_between_uuid_sdx_directory(){
  # Was I given a UUID?  (e.g. 9b0bc44a-d8c1-4630-be6d-da90a1f311d7)
  # fixme? - Is this use of ls portable?  Is that directory structure universal?
  # fixme - a corner case would be a user passing a directory which happens to be exactly called the same as an actual UUID, and intending for it to be processed as a directory.
  [[ -L  /dev/disk/by-uuid/$1 ]]
  if [[ $? -eq 0 ]]; then
    __='uuid'
    return
  fi

  # Was I given some sort of  /dev/sdx  ?
  [[ -b  $1 ]]
  if [[ $? -eq 0 ]]; then
    __='sdx'
    return
  fi

  # Was I given a directory?
  [[ -d  $1 ]]
  if [[ $? -eq 0 ]]; then
    __='directory'
    return
  fi

  _backup_die  "I don't know how to mount "  "$1"
}


_convert_uuid_to_sdx(){
  _distinguish_between_uuid_sdx_directory  $1
  if [[ $__ != 'uuid' ]]; then
    _backup_die  '_convert_uuid_to_sdx was not given a uuid!'
  fi
  _readlink_lazily  /dev/disk/by-uuid/$1
  _basename   $__
  __=/dev/$__
}


# Assumes  /dev/sdx
# use  _convert_uuid_to_sdx()  for UUIDs.
_detect_partition_type(){
  # /dev/sda1  =>  /dev/sda
  # todo - bashism
  local  prefix=${one:0:8}
  
  # /dev/sda1  =>  1
  # todo - bashism

  #regex='.*([[:digit:]]+)'
  # Fixes an issue with sda10 being matched as 0.  I've no clue how to clean up the regex to make it less stupid, it doesn't seem to work as expected.  Fucking regexes.
  regex='...([[:digit:]]+)'
  [[ $one =~ $regex ]]
  local  suffix=${BASH_REMATCH[1]}

  # note - sfdisk requires root access
  # --quiet doesn't actually suppress warning messages, but  `2> /dev/null`  will.
  # The warning I suppress is:
  #     Warning: extended partition does not start at a cylinder boundary.
  #     DOS and Linux will interpret the contents differently.
  echo_info  "Detecting partition type with:  "  "\sfdisk  --force  -n  --print-id  --quiet  $prefix   $suffix"
  # e.g. \sfdisk  --force  -n  --print-id  --quiet  /dev/sda  1        2> /dev/null )
  __=$(  \sfdisk  --force  -n  --print-id  --quiet  $prefix   $suffix  2> /dev/null )
  err  $?
}


# Given a /dev/sdx , a UUID (TODO) or a directory (TODO), process it appropriately, and return a directory of files.
# note - dead/data-migration-lib.sh has smartmount() , which has some ancient code that may be good.
_smart_mount() {
  \echo
  echo_info  'smart_mount() ' "$1  $2  $3"
  # $1 is something to mount/process
  # $2 is 'ro' or 'rw', for read-only and read-write.
  # $3 is an arbitrary name to include in the mount point(s).

  local  one=$1
  local  two=$2
  local  identifier=$3
  __=''

  if [[ -z $one ]]; then
    _backup_die  '_smart_mount() was called with no parameters.'
  fi
  if [[ -z $two ]]; then
    _backup_die  "_smart_mount() was called with no second parameter (either 'ro' or 'rw')."
  fi
  if [[ $two != 'ro'  &&  $two != 'rw' ]]; then
    _backup_die  "_smart_mount() was called with an improper second parameter (either 'ro' or 'rw')."
  fi


  _distinguish_between_uuid_sdx_directory  $one
  local  type=$__
  #if [[ $type = 'directory' ]]; then
    ## FIXME - hackish.
    #local  originally_a_directory='true'
  #fi

  # If given a UUID, convert it to /dev/sdx format for later use.
  if [[ $type = 'uuid' ]]; then
    _convert_uuid_to_sdx  $one
    echo_info  "$one has been found to be "  "$__"
    one=$__
    local  type='sdx'
  fi

  # If I've got a /dev/sdx form
  #   - If not mounted, mount it
  #   - If already mounted, fetch its mount point as a directory reference for later use.
  {
  if [[ $type = 'sdx' ]]; then
    _detect_partition_type  $one
    local  partition_type=$__
    echo_info  'Partition type is '  "$partition_type"
    case  $partition_type  in
      # TODO - more partition types.
      f)
        # TODO - needs to be explicitly tested.
        _backup_die  'This is an extended partition thingy.'
      ;;
      0)
        # TODO - needs to be explicitly tested.
        _backup_die  'This is not a partition.'
      ;;
      7)
        echo_info  'Processing '  'HPFS/NTFS'  ' (e.g. Windows) partition.'
        _check_if_sdx_is_mounted  $one
        if [[ $? -eq 1 ]]; then
          # not mounted
          _fsck_if_not_mounted  $one
          # /dev/sda1  =>  sda1
          _basename  "$one"
          # 2016-03-26 - GNU coreutils mktemp, last tested on Lubuntu 14.04.4 LTS
          smart_mount_working_directory=$( \mktemp  --directory  --suffix=.$identifier.mountpoint  --tmpdir=$working_directory  2>/dev/null )
          if [[ $? == 1 ]]; then
            # 2016-04-07 - OpenBSD 2.1 mktemp, tested on Slackware 14.1
            smart_mount_working_directory=$( \mktemp -d $working_directory.$identifier.bindpoint.XXXXXX )
            err  $?
          fi

          if [[ $two = 'rw' ]]; then
            echo_info  'mounting '  "$one"  ' read-write.'
            \mount  --options $partition_type_7_mount_options,rw  $one  "$smart_mount_working_directory"
            err  $?
          fi
          if [[ $two = 'ro' ]]; then
            echo_info  'mounting '  "$one"  ' read-only.'
            \mount  --options $partition_type_7_mount_options,ro  $one  "$smart_mount_working_directory"
            err  $?
          fi
        fi
        # mounted already, or mounted just now.

        # Give some decent output..
        echo_info  'Some info on '  "$one"  '..'
        \df  --human-readable  --print-type | \grep  $one

        _find_mount_point  $one
        one=$__
        local  type='directory'
      ;;
      82)
        # TODO - needs to be explicitly tested.
        # TODO - Can people legitimately have data on a "Solaris" partition?  So perhaps this ought to process it to differentiate between swap and solaris?
        _backup_die  'This is a '  'Linux Swap / Solaris'  ' partition.'
      ;;
      83)
        echo_info  'Processing '  'Linux'  ' (e.g. ext2, ext3, ext4) partition.'
        _check_if_sdx_is_mounted  $one
        if [[ $? -eq 1 ]]; then
          # not mounted
          _fsck_if_not_mounted  $one
          # /dev/sda1  =>  sda1
          _basename  "$one"
          smart_mount_working_directory=$( \mktemp  --directory  --suffix=.$identifier.mountpoint  --tmpdir=$working_directory  2>/dev/null )
          if [[ $? == 1 ]]; then
            # 2016-04-07 - OpenBSD 2.1 mktemp, tested on Slackware 14.1
            smart_mount_working_directory=$( \mktemp -d $working_directory.$identifier.bindpoint.XXXXXX )
            err  $?
          fi

          if [[ $two = 'rw' ]]; then
            echo_info  'mounting '  "$one"  ' read-write.'
            \mount  --options $partition_type_83_mount_options,rw  $one  "$smart_mount_working_directory" 
            err  $?
          fi
          if [[ $two = 'ro' ]]; then
            echo_info  'mounting '  "$one"  ' read-only.'
            \mount  --option $partition_type_83_mount_options,ro  $one  "$smart_mount_working_directory"
            err  $?
          fi
        fi
        # mounted already, or mounted just now.

        # Give some decent output..
        echo_info  'Some info on '  "$one"  '..'
        \df  --human-readable  --print-type | \grep  $one

        _find_mount_point  $one
        one=$__
        local  type='directory'
      ;;
      *)
        echo_error  "\sfdisk -c /dev/$one  $two  returned"  "$partition_type"
        echo_info  "This script does not know how to handle that."
        echo_info  "Don't worry though, it's not too hard to add support for new types."
        _backup_die  'Aborting.'
      ;;
    esac
  fi
  }


  # Reaching here, things should already be in directory form.
  if [[ $type != 'directory' ]]; then
    _backup_die  'big fat problem with'  '_smart_mount()'
  fi
  smart_mount_working_directory=$( \mktemp  --directory  --suffix=.$identifier.bindpoint  --tmpdir=$working_directory  2>/dev/null )
  # The above will always return 0 if it's "local smart_mount_working_directory=(etc)"  ..  Go figure.
  if [[ $? == 1 ]]; then
    # 2016-04-07 - OpenBSD 2.1 mktemp, tested on Slackware 14.1
    smart_mount_working_directory=$( \mktemp -d $working_directory.$identifier.bindpoint.XXXXXX )
    err  $?
  fi

  if [[ $two = 'rw' ]]; then
    \mount  --options bind,rw  $one  "$smart_mount_working_directory"  > /dev/null
    err  $?
  fi
  if [[ $two = 'ro' ]]; then
    \mount  --options bind,ro  $one  "$smart_mount_working_directory"  > /dev/null
    err  $?
  fi
  __=$smart_mount_working_directory
}


_backup_teardown(){
  \echo
  echo_info  'Performing teardown...'

  if [[ $print_teardown_info = 'true' ]]; then
    \echo
    echo_info  'The contents of ' $working_directory ' is:'
    # note - I use tail because I don't want "total" displayed.
    \ls  --almost-all  -l  $working_directory | \tail --lines +2

    \echo
    echo_info  'The output of '  '\df  --block-size=1  --print-type                   |  \grep  --color '  $working_directory ' is:'
    \df  --block-size=1  --print-type                    |  \grep  --color  $working_directory
    echo_info  'The output of '  '\df  --block-size=1  --print-type  --human-readable |  \grep  --color '  $working_directory ' is:'
    \df  --block-size=1  --print-type  --human-readable  |  \grep  --color  $working_directory

    \echo
    echo_info  'The output of '  '\mount  |  \grep  --color '  $working_directory  ' is:'
    \mount  |  \grep  --color  $working_directory
  fi


  \echo
  echo_info  'Flushing filesystem buffers..'
  \sync

  \echo
  echo_info  'Unmounting stuff..'
  # note/todo - When working with a directory (e.g. root) mounted as a bind point, unmount will say fun things like:
  #   "/ has been unmounted"
  #   instead of something like
  #   "/mnt/tmp.8J96lSX74u.backup.5720/tmp.2XJXpkPgzY.target.bindpoint has been unmounted"
  #
  # note/todo - util-linux 2.20.1  does not list  \mount --verbose  (or any verbosity), but it works.  How odd, broken documentation and it's not even a GNU package.
  \umount  --verbose  $working_directory/*

  \echo
  echo_info  'Removing working directories..'
  \rmdir   --verbose  $working_directory/*
  \rmdir   --verbose  $working_directory
}



# TODO - The exclude list should be unique, depending on what stuff I'm backing up.
#        Perhaps what I ought to do is reference a text file located on $source .
_backup_rsync(){
  \echo
  echo_info  '_backup_rsync() '  "$1  $2"
  local  source=$1
  local  target=$2
  rsync=1
  \nice  --adjustment=19  \rsync  $dry_run \
    --exclude-from=$backup_rsync_exclude_list \
    ` # This is --archive : ` \
    ` # --recursive --links --perms --times --group --owner --devices --specials ` \
    ` #   Which is -rlptgoD (no -H,-A,-X) ` \
    ` #   No --hard-links --acls --xattrs ` \
    --archive \
    ` # Very important! ` \
    --hard-links \
    ` # verbose and progress supposedly slow things down.  I'm not sure how significant they are. ` \
    --verbose \
    ` # This is way too slow: ` \
    ` # --progress ` \
    ` # Files on the target host are updated in the same storage the current version of the file occupies. ` \
    ` # This eliminates the need to use temp files, solving a whole shitload of issues. ` \
    --inplace \
    ` # I don't know how or why there would be sparse files, but this supposedly deals with them intelligently. ` \
    ` # I'm going to remove this for now, to do some more aggressive testing. ` \
    ` # Cannot be used with --inplace ` \
    ` # --sparse ` \
    ` # Skip based on checksum, not mod-time & size: ` \
    ` # --checksum ` \
    --delete \
    ` # --delete-during ` \
    ` # Deleting before doing the copying ensures that there is enough space for new files. ` \
    ` # If --inplace is used, then that ensures that a file can be copied overtop of the backup, and extra space for a copy-on-write isn't needed. ` \
    --delete-before \
    ` # This a bad idea unless you --dry-run to make sure everything works well. ` \
    --delete-excluded \
    ` # Checked for moved files.  This would be wonderful, but --delete-before would conflict.` \
    ` # --fuzzy ` \
    ` # Do not cross filesystem boundaries. ` \
    ` # Important in case you have bound mountpoints, e.g.  mount --bind  or in-place eCryptfs mounts. ` \
    ` # In the case of an eCryptfs directory which has been mounted in-place, it will skip copying from that directory and will not delete any files therein, on the target directory. ` \
    --one-file-system \
    ` # Skip files that are newer on the receiver. ` \
    --update \
    $source/ \
    $target/

  # FIXME? - maybe suppress "unknown file type" errors?

  # Deal with files vanishing on rsync.
  #   rsync warning: some files vanished before they could be transferred (code 24) at main.c(1070) [sender=3.0.9]
  if [[ $? -eq 24 ]]; then
    # Force an exit code of 0.
    \echo
  fi

  # FIXME?  - During a copy, I'll get an I/O error like:
  #   rsync: read errors mapping "/mnt/tmp.beLUxuY3F7.backup.5799/tmp.watySY6q8p.source.bindpoint/wow/_game/Data/expansion2.MPQ": Input/output error (5)
  #
  # To help, I could use  --partial-dir=/foo/bar  and unreadable files would stay there, for debugging.
  # Or perhaps I could investigate some form of logging / parsing.

  err  $?
  rsync=
}
