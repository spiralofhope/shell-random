#!/bin/zsh

# TODO:  What was I thinking with archive/backup-lib.sh  ?  I should probably cut this script apart to put things in an external library like that.  Maybe that's what I was working on.


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

\source /l/Linux/bin/zsh/colours.sh
# Otherwise use rsync.
#backup_method="unison"
# The unison executable.
unison=/home/unison

# --

bullet="${yellow}*${reset}"

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
    if [ -b /dev/sd${i}8 ]; then
      \echo "${bullet} External drive found at /dev/sd${i}"
      external=/dev/sd$i
    fi
  done
  if [ "x$external" = "x" ]; then
    \echo "ERROR:  Backup device not found, aborting!"
    _backup_die
  fi
  # get/set acoustic management (0-254, 128: quiet, 254: fast)
  #\hdparm -M 254 $external
}

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
  \echo "${bullet} Preparing $i .."
  source=/mnt/backup_source/$i/
  dest=/mnt/backup_dest/$i/
  #if [ -d "$source" ] && [ -d "$dest" ]; then
  \mkdir --parents $source $dest
  echo /dev/sda$i $source
  \mount /dev/sda$i $source
  echo $external$i $dest
  \mount $external$i $dest
  #else
    #echo "There's a problem with the source or destination"
    #echo "  $source"
    #echo "  $dest"
    #_backup_teardown
  #fi
}

_backup_unison(){
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

  \echo "${bullet} Syncing $i .."

  # If encountering either a socket or a fifo (named pipe), it gives the message "Error: path /foo/bar has unknown file type." and skips gracefully.
  # http://tech.groups.yahoo.com/group/unison-users/message/7419?var=1&p=3
  # Should I just use rsync for those? .. I don't think I have to worry about attempting to back up either of those things.
  #
  # http://www.cis.upenn.edu/~bcpierce/unison/download/releases/stable/unison-manual.html#caveats
  # Unison does not understand hard links.
  # I don't use hard links anyways.
  \nice -n 19 \
    $unison \
      $source \
      $dest \
      ` # force changes from this replica to the other ` \
      -force $source \
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

  \echo "${bullet} Syncing $i .."
  \nice -n 19 \rsync \
    ` # This is -rlptgoD (no -H,-A,-X) ` \
    ` # Which is --recursive --links --perms --times --group --owner --devices --specials ` \
    ` # No --hard-links --acls --xattrs ` \
    ` # --archive ` \
    --recursive --links --perms --times --group --owner --devices --specials \
    ` # Very important! ` \
    --hard-links \
    ` # These supposedly slow things down.  I'm not sure how significant they are. ` \
    --verbose \
    --progress \
    ` # Files on the target host are updated in the same storage the current version of the file occupies. ` \
    ` # This eliminates the need to use temp files, solving a whole shitload of issues. ` \
    --inplace \
    ` # I don't know how or why there would be sparse files, but this supposedly deals with them intelligently. ` \
    ` # I'm going to remove this for now, to do some more aggressive testing. ` \
    ` # Cannot be used with --inplace ` \
    ` # --sparse ` \
    ` # skip based on checksum, not mod-time & size ` \
    ` # --checksum ` \
    --delete \
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
      --exclude '/l/_inbox/BitTorrent/Transmission-downloading/**.part' \
    ` # This is sometimes a bad idea.. ` \
    --delete-excluded \
    $source \
    $dest
}

_backup_teardown(){
  \echo "${bullet} Cleaning up $i .."
  \umount   /mnt/backup_source/* /mnt/backup_dest/* &> /dev/null
  \rmdir --parents /mnt/backup_source/* /mnt/backup_dest/* &> /dev/null
#  \rmdir --parents /mnt/backup_source/  /mnt/backup_dest/  &> /dev/null
}

# TODO:  Find a more elegant way to do this.
_backup_sdb(){
  \echo "${bullet} Preparing sdb .."
  source=/mnt/backup_source/sdb/
  dest=/mnt/backup_dest/sda7/
  i=7
  if [[ -d $source ]] || [[ -d $dest ]]; then
    _backup_teardown
  fi
  \mkdir --parents $source $dest
  \mount /dev/sdb $source
  \mount /dev/sda$i $dest
  _backup_go
  _backup_teardown
}

_backup_die(){
  _backup_teardown
  \echo ""
  \echo ".. aborted."
  exit 1
}

_backup_go(){
  if [[ $backup_method == "unison" ]]; then
    _backup_unison
    # .unison is a special case.  =/
    if [ $i -eq 6 ]; then
      \echo "${bullet} Manually backing up the unison dot directory.."
      \echo "   It skips backing it up, for some retarded reason."
      \rm \
        --recursive \
        --force \
        /mnt/backup_dest/6/dotunison/ \
        ` # `
      \cp \
        --no-dereference \
        --preserve=links \
        --recursive \
        --verbose \
        /mnt/backup_source/6/dotunison \
        /mnt/backup_dest/6/dotunison \
        ` # `
    fi
  else
    _backup_rsync
  fi
}

# --

# ^c
trap _backup_die INT
_backup_initialize_esata

# TODO:  Deal with multiple numbers sent.  Back those items up.
# $1 needs serious sanity-checking.
if [ -z $1 ]; then
  _backup_mbr
  _backup_sdb
  for i in 1 {6..8}; do
    _backup_setup
    _backup_go
    _backup_teardown
  done
elif [ $1 -eq 7 ]; then
  _backup_sdb
  for i in 7; do
    _backup_setup
    _backup_go
    _backup_teardown
  done
else
  i=$1
  _backup_setup
  _backup_go
  _backup_teardown
fi

\echo ""
\echo ".. done."
exit 0
