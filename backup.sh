#!/bin/zsh

if [ $# -eq 0 ]; then
  echo "help goes here"
  exit 2
fi

_help() {
  echo "help"
}

# Cludge for now
umount /dev/sda1

# Cleaning up if something goes strangely:
#rm -f /mnt/source/*/date.txt /mnt/dest/*/date.txt && umount /mnt/source/* && umount /mnt/dest/* && rmdir -p /mnt/dest/* && rmdir -p /mnt/source/*

# -- TROUBLESHOOTING
# --
# sfdisk returns "b"
# This seems to occur when I first create the partition.  Force-changing its type to "7" seems to work.  e.g. for sdi2:
# sfdisk --change-id /dev/sdi 2 7

# -- TODO
# --
# FIXME -- VERY IMPORTANT - do not use -a (archive) on rsync with an ntfs filesystem (type 7).  Change the code so that the rsync switches are defined when the mount occurs.
# Why did I write this?  I don't remember why rsync+ntfs is bad..  it's bad to do ntfs->ext and ext->ntfs, but I have a cached document with instructions on fixing this.

#   I'm so sick and tired of not trusting the backup of such stuff.  I get funny errors and all that.. and they shouldn't happen.  rsync is a piece of shit and keeps trying to copy things it shouldn't, and I need to do what I can to prevent such nonsense.
# Build a file listing, named by date, and never delete anything from it.
#   I'm sick of losing files and never knowing the filenames to re-download them.
# Convert all "echo" into "vecho" and use $VERBOSE like I do in ruby.
# Add colour.  Need to somehow detect when colour is possible/ok.  Be able to disable it easily.
# check if the sync times are similar, and skip (`continue`) if I've recently completed a full sync
#   can/should I record when I do a partial sync?
# Generate complete listings of all directories (tree)
#  - files
#  - file info (size, etc or the md5sum?)
# Intelligent rsync excludes, depending on what source partition I'm on.
#   So pagefile.sys is only excluded when syncing from sda1
#   Then also exclude temporary and cache directories.  Over a number of syncs, learn what the common cache locations are.
#   user/.BitTornado/datacache/
#   user/bin/BOINC/projects/freehal.net_freehal_at_home
# tmp/
# var/lib/logrotate.status
# var/log/Xorg.0.log
# var/log/auth.log
# var/log/messages
# var/log/rpmpkgs
# var/log/syslog
# var/log/user.log
# var/log/cron/errors.log
# var/log/cron/info.log
# var/log/daemons/info.log
# var/log/gdm/:0.log
# var/spool/anacron/cron.daily
# Leverage an intrusion detection program to really do this right.
# Check to make sure I'm logged in as root.

# Note that if I shred a drive and then start this routine,
# this routine will wait until the shred is done.
# So start this first, then shred.
# shred being:  shred -n 2 -z -v /dev/hdx
#sync

source /home/lib-backup.sh

backup() {
  # The Unity Linux livecd can't handle this?
  for element in ${@[@]}; do
    processing="${cyan}${source}$element => ${dest}$element${reset}"
    \echo -e ""
    \echo -e "${bullet}${bullet}"
    \echo -e "${bullet}${bullet} Processing $processing"
    \echo -e "${bullet}${bullet}"
    \echo -e ""
    \echo -e "${bullet} $processing - Making the working folders..."
    \mkdir -pv /mnt/source/$element
    err $?
    \mkdir -pv /mnt/dest/$element
    err $?
    \echo -e "${bullet} $processing - Mounting source..."
    smartmount $source $element "source"
    err $?
    \echo -e "${bullet} $processing - Mounting destination..."
    smartmount $dest $element "dest"
    err $?

# \mkdir -p /tmp/rsync-backup

#~~~
# Making a tree listing is brutal!
#    \echo -e "${bullet} $processing - Creating tree listing..."
#    \echo `\gvfs-tree --hidden /mnt/source/$element/` >! /mnt/source/$element/tree.txt

    \echo -e "${bullet} $processing - rsync..."
    # --bwlimit=KBPS          limit I/O bandwidth; KBytes per second
#      --bwlimit=10000 \

# Fortress Grand Clean Slate:
#      --exclude '/FGCDIR' \

#      --compress \

# I'd need to do --delete-after to properly use this.
#      --fuzzy \
#      --itemize-changes \

# this is very thorough, but evil on resources
# --checksum \

# Everything works fine but sometimes the rename results metadata
# modifications which will reset the modification time to the current value.
# This is fine except during rename. That's the bug.

# It'd be nice if I could be very exact with the excludes, so that an exclude can be meant for one partition and not another.  Currently this is impossible because the rsync is like `rsync /mnt/source/$element/ /mnt/dest/$element/` and so I cannot --exclude '/mnt/source/1/file' for just partition 1.
   
    rsync=1
    \rsync \
	  ` # --archive is -rlptgoD (no -H,-A,-X) ` \
        --recursive \
        --links \
        ` # Not useful for NTFS. ` \
        --perms \
        --times \
        --group \
        --owner \
      --update \
      ` # Windows sucks and doesn't get the time stamping correct.  This helps. ` \
      --modify-window=2 \
      --devices \
      --specials \
      ` # Files on the target host are updated in the same storage the current version of the file occupies. ` \
      ` # This eliminates the need to use temp files, solving a whole shitload of issues. ` \
      --inplace \
      --delete \
        ` # This is faster: ` \
` #        --delete-during ` \
        ` # If I don't have much space, I need to do this instead: ` \
      --delete-before \
      --hard-links \
      --verbose \
      --progress \
      ` # --stats ` \
      --human-readable \
      ` # WINDOWS ` \
      ` # This includes various versions of Windows.` \
        --exclude 'pagefile.sys' \
        --exclude 'hiberfil.sys' \
        --exclude '/$Recycle.Bin/**' \
        --exclude '/RECYCLER/**' \
        --exclude '/Documents and Settings/*/Local Settings/Application Data/Mozilla/Firefox/Profiles/default/Cache/**' \
        --exclude '/Documents and Settings/*/Local Settings/History/**' \
        --exclude '/Documents and Settings/*/Local Settings/Temporary Internet Files/Content.IE5/**' \
        --exclude '/Documents and Settings/*/Local Settings/Temp/**' \
        --exclude '/Windows/Temp/**' \
        --exclude '/Windows/assembly/temp/**' \
        --exclude '/Windows/assembly/NativeImages_v2.0.50727_32/Temp/**' \
        --exclude '/Windows/Microsoft.NET/Framework/v2.0.50727/Temporary ASP.NET Files/**' \
        --exclude '/Documents and Settings/*/Application Data/Ventrilo/temp/**' \
      ` # LINUX ` \
        --exclude '/tmp/**' \
        --exclude '/home/user/tmp/**' \
        ` # Some sort of GTK thing. ` \
        --exclude '/.Trash-1000/**' \
        ` # Dynamically-generated.  For USB sticks and such. ` \
        --exclude '/media/**' \
        --exclude '/.thumbnails/**' \
        --exclude '/live/Downloads/BitTorrent/Transmission-*/**.part' \
        --exclude '/live/Downloads/**.dtapart' \
      --delete-excluded \
      /mnt/source/$element/ \
      /mnt/dest/$element/
    err $?
    rsync=

    \echo -e "${bullet} $processing - Creating date text file..."
    \echo -e "Last backed up `date`" >! /mnt/source/$element/date.txt

    breaktrap
  done
  \sync
}

# BEGIN
if   [ "x${1}" = "xexternal" ]; then
elif [ "x${1}" = "x5" ] ; then
elif [ "x${1}" = "x6" ] ; then
elif [ "x${1}" = "x8" ] ; then
else
  #for partition in 1 2 3; do
  for partition in 1; do
    source=sda
    dest=sdb
    backup $partition
    if [ "x${external_dest}" != "x" ]; then
      dest=$external_dest
      backup $partition
    fi
  done
fi

if [ "x${external_dest}" != "x" ]; then
  source=sdb
  dest=$external_dest
  if   [ "x${1}" = "x5" ] ; then
    backup     5
  elif [ "x${1}" = "x6" ] ; then
    backup     6
  elif [ "x${1}" = "x8" ] ; then
    backup     8
  else
    backup 5 6 8
  fi
fi

\echo -e "${bullet} Done!"

# -- Rsync Notes
# --
# --inplace
# use --delete-during and then I could also use --fuzzy
# maybe I could delete the files first like this:
# nice -n 10 rsync --archive --min-size=1000GiB --delete-before /mnt/source/ /mnt/dest/
# nice -n 10 rsync --archive --bwlimit=10000 --stats --min-size=1000GiB --delete-before --progress --hard-links /mnt/source/ /mnt/dest/
# nice -n 10 rsync --temp-dir=/mnt/sda9/rsync-temp/ --bwlimit=10000 --stats --sparse --delete-before --archive --hard-links --verbose --progress /mnt/source/ /mnt/dest/
#
# --delete-after --force
# -A -D
#
# rsync \
#   -vaHx \
#   --progress \
#   --numeric-ids \
#   --delete \
#   --exclude-from=asylum_backup.excludes \
#   --delete-excluded \
#   root@asylum:/home/asylum/ \
#   /backup/rsync/asylum/_home_asylum.demo/

# Cludge for now
mount /dev/sda1
