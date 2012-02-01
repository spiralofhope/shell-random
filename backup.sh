# Note that if I shred a drive and then start this routine,
# this routine will wait until the shred is done.
# So start this first, then shred.
# shred being:  shred -n 2 -z -v /dev/hdx
#sync

source=sda
# I always have the secondary HDD in:
dest=sdb

# Search for other candidates:
# HDD
if [ -e /dev/hda8 ] ; then
	dest=hda
fi
if [ -e /dev/hdb8 ] ; then
	dest=hdb
fi
if [ -e /dev/hdc8 ] ; then
	dest=hdc
fi
if [ -e /dev/hdd8 ] ; then
	dest=hdd
fi
# USB/SATA preferred
if [ -e /dev/sdc8 ] ; then
	dest=sdc
fi
if [ -e /dev/sdd8 ] ; then
	dest=sdd
fi
if [ -e /dev/sde8 ] ; then
	dest=sde
fi
if [ -e /dev/sdf8 ] ; then
	dest=sdf
fi
if [ -e /dev/sdg8 ] ; then
	dest=sdg
fi
if [ -e /dev/sdh8 ] ; then
	dest=sdh
fi
if [ -e /dev/sdi8 ] ; then
	dest=sdi
fi

# in case I aborted this script and stuff is hanging around.
if [ -d /mnt/source/ ] || [ -d /mnt/dest/ ]; then
  \echo "* Unmounting everything"
  \umount -f /mnt/source/*
  \umount -f /mnt/dest/*

  \echo "* Removing any old date files"
  rm -f /mnt/source/3/date
  rm -f /mnt/dest/3/date

  \echo "* Removing the working folders"
  rmdir /mnt/source/*
  rmdir /mnt/source/
  rmdir /mnt/dest/*
  rmdir /mnt/dest/
fi

\echo "* Making the directories"
mkdir /mnt/source
mkdir /mnt/source/1
mkdir /mnt/source/2
mkdir /mnt/source/3
mkdir /mnt/source/6
mkdir /mnt/source/7
mkdir /mnt/source/8
if [ $dest = "sdb" ] ; then
  mkdir /mnt/source/9
fi
mkdir /mnt/dest
mkdir /mnt/dest/1
mkdir /mnt/dest/2
mkdir /mnt/dest/3
mkdir /mnt/dest/6
mkdir /mnt/dest/7
mkdir /mnt/dest/8
if [ $dest = "sdb" ] ; then
  mkdir /mnt/dest/9
fi

# Looks like I don't need to do this anymore..
# \echo "* Unmounting the automatic \mounts"
# \umount /dev/$dest\*

\echo "* Checking everything"
/sbin/fsck /dev/$dest\1
/sbin/fsck /dev/$dest\2
/sbin/fsck /dev/$dest\3
/sbin/fsck /dev/$dest\6
/sbin/fsck /dev/$dest\7
/sbin/fsck /dev/$dest\8
if [ $dest = "sdb" ] ; then
  /sbin/fsck /dev/$dest\9
fi

# ISSUES WITH MOUNTING
# Cannot -r (read-only) because it'll complain about already being \mounted
# Cannot (read-only, force) because it'll just be empty when \mounted!
\echo "* Mounting everything nicely"
mount	/dev/$source\1	/mnt/source/1
mount	/dev/$dest\1	/mnt/dest/1
# unisonsync.sh /mnt/source/1 /mnt/dest/1
# source1=$?

mount	/dev/$source\2	/mnt/source/2
mount	/dev/$dest\2	/mnt/dest/2
# unisonsync.sh /mnt/source/2 /mnt/dest/2
# source2=$?

mount	/dev/$source\3	/mnt/source/3
mount	/dev/$dest\3	/mnt/dest/3
# unisonsync.sh /mnt/source/3 /mnt/dest/3
# source3=$?

mount	/dev/$source\6	/mnt/source/6
mount	/dev/$dest\6	/mnt/dest/6
# unisonsync.sh /mnt/source/6 /mnt/dest/6
# source6=$?

mount	/dev/$source\7	/mnt/source/7
mount	/dev/$dest\7	/mnt/dest/7
# unisonsync.sh /mnt/source/7 /mnt/dest/7
# source7=$?

mount	/dev/$source\8	/mnt/source/8
mount	/dev/$dest\8	/mnt/dest/8
# unisonsync.sh /mnt/source/8 /mnt/dest/8
# source8=$?

if [ $dest = "sdb" ] ; then
  \mount	/dev/$source\9	/mnt/source/9
  \mount	/dev/$dest\9	/mnt/dest/9
  # unisonsync.sh /mnt/source/9 /mnt/dest/9
  # source9=$?
fi

\echo "* Synchronizing"
\echo "- remember that this doesn't back up the server!"
# Seems to break down when I'm low on disk space..
rsync --archive --bwlimit=10000 --verbose --delete-before --progress /mnt/source/ /mnt/dest/


# --bwlimit=KBPS          limit I/O bandwidth; KBytes per second
# --inplace
# If I could avoid --delete-before the backup would run way faster
# I could just make this an hourly cron job if I wanted to.  Then regular backups would reduce the problem of having a new file
# of such a size that it could not be copied to the backup drive.
# use --delete-during and then I could also use --fuzzy
# maybe I could delete the files first?
# nice -n 10 rsync --archive --min-size=1000GiB --delete-before /mnt/source/ /mnt/dest/
# nice -n 10 rsync --archive --bwlimit=10000 --stats --min-size=1000GiB --delete-before --progress --hard-links /mnt/source/ /mnt/dest/
# nice -n 10 rsync --temp-dir=/mnt/sda9/rsync-temp/ --bwlimit=10000 --stats --sparse --delete-before --archive --hard-links --verbose --progress /mnt/source/ /mnt/dest/

# --delete-after --force 
# -A -D

# rsync -vaHx --progress --numeric-ids --delete \
# --exclude-from=asylum_backup.excludes --delete-excluded \
# root@asylum:/home/asylum/ /backup/rsync/asylum/_home_asylum.demo/

\echo "* Adding dates"
\echo "Last backed up:">/mnt/source/3/date
date > /mnt/source/3/date

\echo "Backup created on:">/mnt/dest/3/date
date > /mnt/dest/3/date

\echo "* Listing disk space"
df

\echo "* Listing success"
#\echo "source1 =" $source1
#\echo "source2 =" $source2
#\echo "source3 =" $source3
#\echo "source6 =" $source6
#\echo "source7 =" $source7
#\echo "source8 =" $source8
#\echo "source9 =" $source9

#\echo "* Sync a few times"
#sync
#sync
#sync

\echo "* Unmounting everything"
# Note that I do NOT force this \umount.
\umount /mnt/source/*
\umount /mnt/dest/*

\echo "* Removing the working folders"
# I also don't do any rm -rf nonsense here.  That is really unsafe.
rmdir /mnt/source/*
rmdir /mnt/source/
rmdir /mnt/dest/*
rmdir /mnt/dest/
