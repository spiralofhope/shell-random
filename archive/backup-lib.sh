#for i in /home/user/bin/zsh/*.sh; do
  #source "$i"
#done
source /home/user/bin/zsh/colours.sh
bullet="${yellow}*${reset}"

err() {
  if [ "x$1" = "x0" ]; then
    return $1
  fi
  if [ "x$rsync" = "x1" ]; then
    # If I've just been running `rsync`
    if [ "x$1" = "x24" ]; then
      \echo -e "${bullet} $processing - $processing - Rsync exited with code 24.  No problem."
      return $1
    fi
    if [ "x$1" = "x23" ]; then
      \echo -e "${bullet} $processing - Rsync exited with code 23.  No problem."
      return $1
    fi
  fi

  \echo -e "${bullet} $processing - ${red}ERROR:  Non-zero exit code \"$1\" received, aborting!${reset}"
  # Note that this command won't be found if this script doesn't get far enough into its routine..
  breaktrap

  # FIXME: How do exit with a status of $1 ?
  exit
  # I could also do a `continue` to move on to the other partitions.
  # But I would need a mechanism for saving up these notifications
  # and printing them at the end like I do with my Ruby unit tests.
  # Continuing is probably a bad notion anyways.
}

smartmount() {
  \echo -e "${bullet} $processing - Detecting partition type with sfdisk -c /dev/$1 $2..."
  # Note:  sfdisk requires root access
  i=`\sfdisk -c /dev/$1 $2`
  case $i in
    f)
      \echo -e "${bullet} $processing - ${yellow}WARNING:  \"sfdisk -c /dev/$1 $2\" returned \"$i\"${reset}"
      \echo -e "${bullet} $processing - This is an extended partition thingy, skipping it."
      return 0
    ;;
    0)
      \echo -e "${bullet} $processing - ${yellow}WARNING:  \"sfdisk -c /dev/$1 $2\" returned \"$i\"${reset}"
      \echo -e "${bullet} $processing - This is not a partition, skipping it."
      return 0
    ;;
    7)
      \echo -e "${bullet} $processing - HPFS/NTFS detected"
      # Using `ntfsmount` because `mount` doesn't allow read-write access.
      # http://www.linux-ntfs.org
      if [ "x$3" = "xsource" ]; then
        # regular mount is read-only
        # Better not mount read-only, so that I can have a proper date.txt
        #\mount /dev/$1$2 /mnt/$3/$2
#        \ntfsmount /dev/$1$2 /mnt/$3/$2

# r-w functionality seems to be built-in in Lubuntu 10.10 and may actually make `mount` better than `ntfsmount`.
        \mount /dev/$1$2 /mnt/$3/$2
      else
#        \ntfsmount /dev/$1$2 /mnt/$3/$2
# r-w functionality seems to be built-in in Lubuntu 10.10 and may actually make `mount` better than `ntfsmount`.
        \mount /dev/$1$2 /mnt/$3/$2
      fi

      err $?

# I've seen the following error occur when I was browsing the mounted filesystem as a regular user.
# The script completely bombed out and nothing was triggered after this rsync failure
# This was due to the destination running out of space.
# FIXME:  Check for free space somehow?  Sigh, this shouldn't be needed!

# rsync: writefd_unbuffered failed to write 4 bytes to socket [sender]: Broken pipe (32)
# rsync: connection unexpectedly closed (84216 bytes received so far) [sender]
# rsync error: error in rsync protocol data stream (code 12) at io.c(600) [sender=3.0.6]
    ;;
    82)
      \echo -e "${bullet} $processing - ${yellow}WARNING:  \"sfdisk -c /dev/$1 $2\" returned \"$i\"${reset}"
      \echo -e "${bullet} $processing - This is a Linux Swap / Solaris partition, skipping it."
      return 0
    ;;
    83)
      \echo -e "${bullet} Linux (e.g. ext2, ext3, ext4) detected"
      # Learn if the filesystem is not mounted, so I can use fsck safely.
      # I'd use `mount` or `cat /proc/mounts` but they don't show the root filesystem!

      fsck=good
      for line in `df | cut -d' ' -f1 | cut -d'/' -f3`; do
        if [ $line = $1$2 ]; then fsck=bad ; fi
      done
      if [ "x$fsck" = "xgood" ]; then
        \echo -e "${bullet} $processing - /dev/$1$2 is not mounted, running fsck..."
        \fsck /dev/$1$2
        err $?
        \echo -e "${bullet} $processing - /dev/$1$2 is not mounted, mounting to /mnt/$3/$2..."
        if [ "x$3" = "xsource" ]; then
          # Better not mount read-only, so that I can have a proper date.txt
          # \mount --read-only /dev/$1$2 /mnt/$3/$2
          \mount /dev/$1$2 /mnt/$3/$2
        else
          \mount /dev/$1$2 /mnt/$3/$2
        fi
        err $?
      elif [ "x$fsck" = "xbad" ]; then
        \echo -e "${bullet} $processing - /dev/$1$2 is already mounted, attempting to do a second mount to /mnt/$3/$2..."
        # Cannot --read-only because it'll complain about already being mounted
        # Cannot (read-only, force) because it'll just be empty when mounted!
        #   How do I force?  I don't see the option..
        # TODO:  --bind, but I have to learn where the old mount point is first..
        # I can learn the device with `findfs LABEL=ext1` .. but that's not what I want.
        \mount /dev/$1$2 /mnt/$3/$2
        err $?
      else
        \echo -e "${bullet} $processing - ${red}ERROR:  Something is really wrong.  Check the code!${reset}"
        \echo -e "${bullet} $processing - Skipping this partition."
        return 1
      fi
    ;;
    *)
      \echo -e "${bullet} $processing - ${red}ERROR:  \"sfdisk -c /dev/$1 $2\" returned \"$i\"${reset}"
      \echo -e "${bullet} $processing - I don't know how to mount that.  Exiting."
      return 1
    ;;
  esac
}

# Moved to the top level so it's usable by the windows-related crap.
trap breaktrap INT
breaktrap() {
  \sync
  \echo -e "${bullet} $processing - Listing disk space..."
  \echo -e "\df /dev/${source}$element"
  \df /dev/${source}$element
  \echo -e "\df /dev/${dest}$element"
  \df /dev/${dest}$element
  \echo -e "${bullet} \`sync\` to avoid 'device is busy' issues during ^c"
  \sync
  \echo -e "${bullet} $processing - Umounting..."
  \echo -e "\umount /mnt/source/$element"
  \umount /mnt/source/$element
  \echo -e "\umount /mnt/dest/$element"
  \umount /mnt/dest/$element
  \echo -e "${bullet} $processing - Removing the working folders..."
  # I'm not sure why I did this.
  OWD=$PWD
  \cd /mnt
  \rmdir -pv source/$element
  \rmdir -pv dest/$element
  \cd $OWD
  \sync
}

get_external() {
  # NOTE:  The number will change depending upon which USB port the eSATA bay was plugged into.  So let's just scan everything.
  \echo -e "${bullet} Initialising the eSata / re-checking for a device..."
  for i in 0 1 2 3 4 5 6; do
    \scsiadd -s $i &>> /dev/null
  done
  \echo -e "${bullet} Sleeping to let external devices initialize..."
  \sleep 4
  for drive in c d e f g h i j k l m n o p q r s t u v w x y z; do
    if [ -e /dev/sd${drive}8 ] ; then
      # FIXME: This is pretty blind, I should mount it (and see that the mount works) and check for a control file.
      \echo -e "${bullet} Found an external drive at ${cyan}/dev/sd${drive}${reset}"
      \echo -e "  Also backing up ${cyan}/dev/sda${reset}"
      external_dest="sd$drive"
      return
    fi
  done
  if [ "x$external_dest" = "x" ]; then
    \echo -e "${bullet} ${cyan}No external drive was found.${reset}"
    \echo -e "  Only backing up ${cyan}/dev/sda${reset}"
  fi
}
get_external
