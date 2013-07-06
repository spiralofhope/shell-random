#!/usr/bin/env  sh


# When mounting read-write, mount with risky performance options.
#   - Anything I mount for writing will be more-or-less exclusively mounted by this script.
#   - Writing is only being done to a location where its contents don't matter so much.
# Problem 1 - I need to research and properly understand such options.
# Problem 2 - The options are different per filesystem.
#             So I could have partition type 83, ext4 or btrfs, which have different mount options.
#partition_type_83_mount_options=nouser,noatime,data=writeback,barrier=0,nobh
# nobarrier exists, but they give a healthy warning.
#partition_type_83_mount_options=nouser,noatime,nobh
# This seems universal.  
# Actually, btrfs didn't list nouser as of 2013-07-05.  But I see mentions of it elsewhere.
#   https://btrfs.wiki.kernel.org/index.php/Mount_options
partition_type_83_mount_options=nouser,noatime



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



echo_info(){
  \echo  \ ${yellow}info${reset} \ - $1${yellow}$2${reset}$3
}



# TODO - the rsync idea has not been re-integrated.
err() {
  if [ "x$1" = "x0" ]; then
    return  $1
  fi
  if [ "x$rsync" = "x1" ]; then
    # If I've just been running `rsync`
    if [ "x$1" = "x24" ]; then
      \echo  -e "${bullet} $processing - $processing - Rsync exited with code 24.  No problem."
      return  $1
    fi
    if [ "x$1" = "x23" ]; then
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
  #         Perhaps I could:  `\cat /proc/self/mounts`  but does that pose portability concerns?
  \mount  |  \cut  -d' '  -f1  |  \grep  --quiet  $1
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
  __=$( \mount  |  \grep  $1  |  \cut  -d' '  -f3  )
}



# This assumes  /dev/sdx  format.
_fsck_if_not_mounted() {
  _check_if_sdx_is_mounted  $1
  if [ $? -eq 1 ]; then
    # TODO - needs to be live-tested.
    echo_info  "$1 is "  'not mounted'  ', performing fsck.'
    \fsck  $1
    __=$?
    if [ $__ -eq 8 ]; then
      _backup_die  'fsck gave error ' 8 ', perhaps you need to install btrfs-tools or another similar package.'
    fi
    err  $__
  else
    echo_info  "$1 is "  'mounted' ', skipping fsck.'
  fi
}



# TODO - It would be nice to have a  readlink  replacement for bash, but that seems horribly complicated.  Why in the fuck isn't it just an option with  `ls`  ?  Oh right, it's GNU.
#   filename -> ../../sda1            =>   ../../sda1
# Even if the filename is stupid, it works.
#   file -> name -> ../../sda1        =>   ../../sda1
_readlink_lazily(){
  __=$( \ls  -l  "$1" )
  err  $?
  __=${__##* -> }
}



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

  regex='.*([[:digit:]]+)'
  [[ $one =~ $regex ]]
  local  suffix=${BASH_REMATCH[1]}

  # note - sfdisk requires root access
  # --quiet doesn't actually suppress warning messages, but  `2> /dev/null`  will.
  # The warning I suppress is:
  #     Warning: extended partition does not start at a cylinder boundary.
  #     DOS and Linux will interpret the contents differently.
  echo_info  "Detecting partition type with:  "  "\sfdisk  -n  --print-id  --quiet  $prefix   $suffix"
  # e.g.                    \sfdisk  -n  --print-id  --quiet  /dev/sda  1        2> /dev/null )
  __=$(  \sfdisk  -n  --print-id  --quiet  $prefix   $suffix  2> /dev/null )
  err  $?
}


# Given a /dev/sdx , a UUID (TODO) or a directory (TODO), process it appropriately, and return a directory of files.
# note - dead/data-migration-lib.sh has smartmount() , which has some ancient code that may be good.
_smart_mount() {
  # $1 is something to mount/process
  # $2 is 'ro' or 'rw', for read-only and read-write.

  local  one=$1
  local  two=$2
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

  # If given a UUID, convert it to /dev/sdx format for later use.
  if [[ $type = 'uuid' ]]; then
    _convert_uuid_to_sdx  $one
    one=$__
    local  type='sdx'
  fi

  # If I've got a /dev/sdx form
  #   - If not mounted, mount it
  #   - If already mounted, fetch its mount point as a directory reference for later use.
  {
  if [[ $type = 'sdx' ]]; then
    _detect_partition_type  $one
    echo_info  'Partition type is '  "$__"
    case  $__  in
      # TODO - more partition types.
      83)
        echo_info  'Processing '  'Linux'  ' (e.g. ext2, ext3, ext4) partition.'
        _check_if_sdx_is_mounted  $one
        if [[ $? -eq 1 ]]; then
          # not mounted
# ++++++++++++++++++++
# Disabled for testing
# ++++++++++++++++++++
          #_fsck_if_not_mounted  $one
          # /dev/sda1  =>  sda1
          _basename  "$one"
          local  smart_mount_working_directory="$working_directory/$__".mountpoint
          \mkdir  --parents  "$smart_mount_working_directory"
          if [[ $two = 'rw' ]]; then
            echo_info  'mounting '  "$one"  ' read-write.'
            \mount  -o $partition_type_83_mount_options,rw  $one  "$smart_mount_working_directory"  ;  err  $?
          fi
          if [[ $two = 'ro' ]]; then
            echo_info  'mounting '  "$one"  ' read-only.'
            \mount  -o $partition_type_83_mount_options,ro  $one  "$smart_mount_working_directory"  ;  err  $?
          fi
        fi
        # mounted already, or mounted just now.

        # Give some decent output..
        \df  --human-readable  --print-type | \grep $one
        #_readlink_lazily  /dev/disk/by-uuid/$source  ; _basename   $__  ; \df  --human-readable  --print-type | \grep $__

        _find_mount_point  $one
        one=$__
        local  type='directory'
      ;;
      *)
        echo_error  "\sfdisk -c /dev/$source  $target  returned"  "$partition_type"
        _backup_die  "I don't know how to mount that"  'Exiting.'
      ;;
    esac
  fi
  }

  # Reaching here, things should already be in directory form.
  if [[ $type != 'directory' ]]; then
    _backup_die  'big fat problem with'  '_smart_mount()'
  fi

  local  smart_mount_working_directory="$working_directory/$$".bindpoint
  \mkdir  --parents  "$smart_mount_working_directory"

  if [[ $two = 'rw' ]]; then
    \mount  -o bind,rw  $__  "$smart_mount_working_directory"  ;  err  $?
  fi
  if [[ $two = 'ro' ]]; then
    \mount  -o bind,ro  $__  "$smart_mount_working_directory"  ;  err  $?
  fi

  __=$smart_mount_working_directory
}


_backup_teardown(){
  echo_info  'Performing teardown...'

  # Might be useful for debugging
  \echo
  echo_info  'The contents of ' $working_directory ' is:'
  # note - I use tail because I don't want "total" displayed.
  #        Whatever the hell that means.
  \ls  --almost-all  -l  $working_directory | \tail --lines +2
  \echo
  \df \
    ` # --human-readable ` \
    --print-type \
    ` # `
  \echo
  \mount | \grep  --color  $working_directory
  \echo

  # note/todo - Then working with the root turned into a bind point - this will say fun things like
  #   "/ has been unmounted"
  #   instead of
  #   "/mnt/_backup.23131/23131.bindpoint has been unmounted"
  #
  # note/fixme - For some reason, calling  \umount *  once doesn't work.  The bindpoint stays mounted!
  #   This also doesn't work:
  #     for dir in $working_directory/*; do
  #       \umount  --verbose  $dir
  #     done
  #   .. calling it twice works.  Fucked if I know what's going on.
  #
  # note/todo - util-linux 2.20.1  does not list  \mount --verbose  (or any verbosity), but it works.  How odd, broken documentation and it's not even a GNU package.
  \umount  --verbose  $working_directory/*
  \echo
  \umount  --verbose  $working_directory/*
  \echo

  # Using err within _backup_teardown is a bad idea which could lead to an infinite loop.
  # So I'm using it after _backup_teardown() gets called.
  \rmdir   --verbose  $working_directory/* # ;  err  $?
  \rmdir   --verbose  $working_directory   # ;  err  $?
}
