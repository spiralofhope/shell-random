#!/usr/bin/env  zsh
# FIXME URGENT -- errors thrown by rsync should abort additional backups!  Go back to old code and re-implement it!



# FIXME:  This shouldn't be bash or zsh-centric

# TODO:  Move self-specific stuff into a configuration file, and use that.  Make this more generic.


# TODO:  Push stuff into an external lib and `source` it.  I see that I made archive/backup-lib.sh which is used by archive/data-migration.sh

# TODO:  Copy the MBR into a file / script which can be re-run to restore that info.. I often won't have access to the eSATA to restore in that manner.

# TODO:
# - File tree.
# - Time the backups?
# skip rpm database stuff - hell, check the list of stuff to clean up when remastering, that'd be good to work off of.
# maybe suppress unknown file type errors?
# peek into the backup partitions and delete anything I'm excluding via unison.  then confirm they're being skipped!


# Go to sleep.
# I wish I could lock it from further use until manually power-cycled.
# Disabled, as it's really inconvenient when I'm doing testing.
#\hdparm -Y $external
\source /l/shell-random/git/live/zsh/colours.sh
\source /l/shell-random/git/live/lib.sh
# backup_method="unison"
backup_method="rsync"
# The unison executable, if used.
#unison=/home/unison

# --

bullet=" ${yellow}*${reset}"


# TODO:  This is obsolete, isn't it?
_backup_initialize_esata(){
  # NOTE:  The number will change depending upon which USB port the eSATA bay was plugged into.  So let's just scan everything.
  # If the OS isn't magical, I'd have to use `scsiadd` and do a scan like so:
  #\echo -e "${bullet} Initializing the eSata / re-checking for a device..."
  #for i in {0..6}; do
    #/usr/local/sbin/scsiadd -s $i &>> /dev/null
  #done
  # It needs a moment to actually kick in.
  # Meh, it's smart enough to fail if it needs to, and I re-run it too frequently to want to wait two seconds.
  # \sleep 2

  for i in c d e f g h i j k l m n o p q r s t u v w x y z; do
    if [ -b /dev/sd${i}7 ]; then
      external=/dev/sd$i
      \echo "${bullet} External drive found at $external"
    fi
  done
  if [ "x$external" = "x" ]; then
    \echo "ERROR:  Backup device not found, aborting!"
    _backup_die
  fi
  # get/set acoustic management (0-254, 128: quiet, 254: fast)
  #\hdparm -M 254 $external
}


# MBR TODO:
_backup_mbr(){
  \echo "${bullet} Cloning the MBR... (boot record only, not the partition table)"
  \dd \
    if=/dev/sda \
    of=$external \
    bs=446 \
    count=1 \
    ` # `
}


_backup_setup(){
  \echo "${bullet} _backup_setup : ${1:t} => ${2:t} .."

  if ! [ -L /dev/disk/by-uuid/$1 ]; then
    \echo  "ERROR:  Could not find UUID:  $1"
    _backup_die
  fi
  if ! [ -L /dev/disk/by-uuid/$2 ]; then
    \echo  "ERROR:  Could not find UUID:  $2"
    _backup_die
  fi

  source=/mnt/backup_source/${1}/
  target=/mnt/backup_target/${2}/

  \mkdir --parents  $source
  \mkdir --parents  $target
  \mount -U  $1  $source
  \mount -U  $2  $target

  \df  --human-readable --print-type | \grep $1
  \df  --human-readable --print-type | \grep $2
}


_backup_unison(){
  \echo "${bullet} : _backup_unison : ${1:t} => ${2:t} .."

  # Check for, and repair, the unison dotdir.
  # My /root/.unison is actually found on the data partition, so I don't overwrite it upon system-reinstallation.
  if [ -L ~/.unison ]; then
    # It's already symbolically-linked.
  else
    # Directory
    if [ -d ~/.unison ]; then
      \rm -rf ~/.unison
    fi
    \echo "${bullet} First run?  Creating the ~/.unison symlink."
    ln -s /home/dotunison ~/.unison
  fi

  # If encountering either a socket or a fifo (named pipe), it gives the message "Error: path /foo/bar has unknown file type." and skips gracefully.
  # http://tech.groups.yahoo.com/group/unison-users/message/7419?var=1&p=3
  # Should I just use rsync for those? .. I don't think I have to worry about attempting to back up either of those things.
  #
  # http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#caveats
  # Unison does not understand hard links.
  # I don't use hard links anyways.
  \nice -n 19 \
    $unison \
      $1 \
      $2 \
      ` # force changes from this replica to the other ` \
      -force $1 \
      -batch \
      -log=false \
      ` # maximum number of simultaneous file transfers ` \
      ` # Probably a bad idea to enlarge. ` \
      -maxthreads=1 \
      -copymax=1 \
      -owner \
      -group \
      -times \
      -contactquietly \
      -ignore 'Regex WoW/World of Warcraft/Logs/WoWCombatLog.txt' \
      ` # I don't know how to be more specific than this.  Dammit! ` \
      -ignore 'Name *.dtapart' \
    ` # LINUX ` \
      ` # FIXME:  I don't know how the fuck to make it properly ignore paths!!  It still spits out error messages when it should be ignoring the path. ` \
      -ignore 'Regex lost+found/.*' \
      -ignore 'Regex dev/.*' \
      -ignore 'Regex tmp/.*' \
      ` # Dynamically-generated.  For USB sticks and such: ` \
      -ignore 'Regex media/.*' \
      ` # Some sort of GTK undelete trash bin: ` \
      -ignore 'Regex root/.Trash-.*/' \
      -ignore 'Regex user/.Trash-.*' \
      ` # FIXME:  This isn't working? ` \
      -ignore 'Regex root/.thumbnails/.*' \
      -ignore 'Regex user/.thumbnails/.*' \
      -ignore 'Regex root/tmp/.*' \
      -ignore 'Regex user/tmp/.*' \
      ` # Note that I'm choosing not to do Transmission-*/**.part anymore, which includes Transmission-completed, because I sometimes have nearly-completed things which are bloody hard to get completely downloaded, which I *do* want backed up:` \
      -ignore 'Regex l/Downloads/BitTorrent/Transmission-downloading/.*\.part' \
      ` # `
}


_backup_rsync(){
  #` # WINDOWS ` \
  #` # This includes various versions of Windows.` \
    #--exclude 'pagefile.sys' \
    #--exclude 'hiberfil.sys' \
    #--exclude '/$Recycle.Bin/**' \
    #--exclude '/RECYCLER/**' \
    #--exclude '/Documents and Settings/*/Local Settings/Application Data/Mozilla/Firefox/Profiles/default/Cache/**' \
    #--exclude '/Documents and Settings/*/Local Settings/History/**' \
    #--exclude '/Documents and Settings/*/Local Settings/Temporary Internet Files/Content.IE5/**' \
    #--exclude '/Documents and Settings/*/Local Settings/Temp/**' \
    #--exclude '/Windows/Temp/**' \
    #--exclude '/Windows/assembly/temp/**' \
    #--exclude '/Windows/assembly/NativeImages_v2.0.50727_32/Temp/**' \
    #--exclude '/Windows/Microsoft.NET/Framework/v2.0.50727/Temporary ASP.NET Files/**' \
    #--exclude '/Documents and Settings/*/Application Data/Ventrilo/temp/**' \

  \echo "${bullet} _backup_rsync : ${1:t} => ${2:t} .."
  \nice -n 19 \rsync \
    ` # This is -rlptgoD (no -H,-A,-X) ` \
    ` # Which is --recursive --links --perms --times --group --owner --devices --specials ` \
    ` # No --hard-links --acls --xattrs ` \
    ` # This is --archive : ` \
    --recursive --links --perms --times --group --owner --devices --specials \
    ` # Very important! ` \
    --hard-links \
    ` # These supposedly slow things down.  I'm not sure how significant they are. ` \
    --verbose \
    ` # Way too slow. ` \
    ` # --progress ` \
    ` # Files on the target host are updated in the same storage the current version of the file occupies. ` \
    ` # This eliminates the need to use temp files, solving a whole shitload of issues. ` \
    --inplace \
    ` # I don't know how or why there would be sparse files, but this supposedly deals with them intelligently. ` \
    ` # I'm going to remove this for now, to do some more aggressive testing. ` \
    ` # Cannot be used with --inplace ` \
    ` # --sparse ` \
    ` # skip based on checksum, not mod-time & size ` \
    ` # --checksum ` \
    ` # --delete ` \
    ` # --delete-during ` \
    ` # Deleting before doing the copying ensures that there is enough space for new files. ` \
    ` # If --inplace is used, then that ensures that a file can be copied overtop of the backup, and extra space for a copy-on-write isn't needed. ` \
    --delete-before \
      ` # Downthemall, Firefox extension.  Temporary files. ` \
      --exclude '*-{????????-????-????-????-????????????}.dtapart' \
    ` # LINUX ` \
      --exclude '/tmp/**' \
      --exclude '/home/user/tmp/**' \
      --exclude 'user/tmp/Firefox Cache/**' \
      ` # Some sort of GTK thing. ` \
      --exclude '/.Trash-*/**' \
      ` # Dynamically-generated.  For USB sticks and such. ` \
      --exclude '/media/**' \
      --exclude '/.thumbnails/**' \
      ` # Note that I'm choosing not to do Transmission-*/**.part anymore, which includes Transmission-completed, because I sometimes have nearly-completed things which are bloody hard to get completely downloaded, which I *do* want backed up.` \
      --exclude '/_inbox/BitTorrent/Transmission-incomplete/**.part' \
    ` # This is sometimes a bad idea.. ` \
    --delete-excluded \
    $1 \
    $2
}


_backup_teardown(){
  \echo  "${bullet} _backup_teardown .."
  \sleep  1
  \df  --print-type
  # \ls  -al  /mnt/backup_target
  \umount   /mnt/backup_source/*  &>  /dev/null
  \umount   /mnt/backup_target/*  &>  /dev/null
  \rmdir   /mnt/backup_source/*  &>  /dev/null
  \rmdir   /mnt/backup_target/*  &>  /dev/null
  \rmdir   /mnt/backup_*
}


_backup_die(){
  _backup_teardown
  \echo ""
  \echo ".. aborted."
  exit 1
}


_backup_go(){
  if [[ $backup_method == "unison" ]]; then
    _backup_unison  $1  $2
    # .unison is a special case.  =/
    if [ $i -eq 7 ]; then
      \echo "${bullet} Manually backing up the unison dot directory.."
      \echo "   It skips backing it up, for some retarded reason."
      \rm \
        --recursive \
        --force \
        /mnt/backup_target/$i/dotunison/ \
        ` # `
      \cp \
        --no-dereference \
        --preserve=links \
        --recursive \
        --verbose \
        /mnt/backup_source/$i/dotunison \
        /mnt/backup_target/$i/dotunison \
        ` # `
    fi
  elif [[ $backup_method == "rsync" ]]; then
    if [ $i -eq 7 ]; then
      _backup_rsync  /opt/bitnami/  /z/mediawiki/bitnami/
    fi
    _backup_rsync  $1  $2
  else
    \echo  "Bad configuration"
    _backup_teardown
  fi
}


_backup_some_number() {
  # TODO:  Sanity-checking.

  _backup_routine() {
    _backup_setup  $1  $2
    _backup_go  $source  $target
    _backup_teardown
  }

  case $1 in
    1)
      # Note:  The SSD's first partition is NOT backed up!
      #        This is intentional, it's disposable.
      #
      # sda1 => sde1
      _backup_routine \
        572c9c6c-10d1-4852-88f9-3034f09e24e9 \
        65f67d30-78a8-432c-94af-a04e7c783e1a

    ;;
    3)
      # Note:  There is no third partition on the hdd.
      #
      # sdb3 => sda6 (ssd => active-hdd)
      _backup_routine \
        f9c27b3a-f9f6-4bc9-aed4-7d399392db75 \
        c9163085-f8ba-40c3-9bce-0b35bfc97dec
    ;;
    5)
      # sda5 => sde5
      _backup_routine \
        4fdd2100-8d4c-41b0-86d6-2a6f604aab23 \
        9d1e9f17-6d93-4260-b601-443e491e9613
    ;;
    6)
      # sda6 => sde6 (hdd => backup-hdd)
      _backup_routine \
        c9163085-f8ba-40c3-9bce-0b35bfc97dec \
        b49165cc-3cb4-437b-af51-6fb011dea901
    ;;
    7)
      # Back up the manual bitnami installation.
      \rsync -av --progress --delete \
        /opt/bitnami/ \
        /mnt/data/zombie/mediawiki/bitnami/
      # sda7 => sde7
      _backup_routine \
        1f853f52-ebdc-4926-9d76-88b38c1757d5 \
        54cf9f5d-827a-4c40-a4d5-d65f1e19b662
    ;;
    *)
      \echo  'failed case statement'
    ;;
  esac
}


# --

# ^c
trap _backup_die INT
# FIXME - this is a dependency I should absorb or have explicitly in a backup-lib.sh, so that others can use this more easily.
#be_root_or_die
if [ $(whoami) != "root" ]; then
  \echo "ERROR:  You're not root!"
  exit 1
fi


# TODO:  This is obsolete, isn't it?
# _backup_initialize_esata
# TODO:  $1 needs serious sanity-checking.
if [ -z $1 ]; then
  # MBR TODO:
  #_backup_mbr /dev/sda  $external


  for i in 1 3 5 6 7; do
    _backup_some_number $i
  done
else
  for i in $@; do
    _backup_some_number $i
  done
fi

\echo  "${bullet} done."
exit 0
