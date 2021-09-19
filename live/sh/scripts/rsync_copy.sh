#!/usr/bin/env  sh



# NOT FOR PRODUCTION USE
# This is a work in progress copied from several backup script projects.

# It has not been directly tested or used in production and is here for reference.  One day I'll bring all the various backup projects online, and have the most current stuff be maintained public-facing.  Until then, here's some options because rsync is fucking rediculous.



# Uncopyable to NTFS and aren't useful to back up anyway:
#   s  Character (unbuffered) special
#   p  Named pipes (FIFOs)
#   s  Sockets
#   find -type c,p,s  -delete

exit  0


# Copy via rsync
# TODO - this was roughly copied from some random backup scrupt, so it may not be my most recent thing.
# FIXME - deal with NTFS

# TODO - verbosity

# TODO - improve this
dry_run='--dry-run'


# TODO - investigate
#  --acls
#  --xattrs


# rsync --dry-run -rvh --size-only --progress --links /source  /target


for signal in INT QUIT HUP TERM USR1; do
  trap "
    _teardown
    trap - $signal EXIT
    \kill  -s $signal "'"$$"' "$signal"
done
trap _teardown EXIT
_teardown() {
  \echo  TODO
}


_rsync_copy() {
  directory_source="$1"
  directory_target="$2"
  exclude_from="$3"

  #\ionice  --class 2 --classdata 5  \
  #\nice  --adjustment=19  \


  \rsync  \
    $dry_run  \
    --delete  --delete-during  --delete-excluded  \
    --exclude-from="$exclude_from"  \
    --hard-links  \
    --verbose  --itemize-changes  --progress  \
    --archive                                                         `# Expands to --recursive --links --perms --times --group --owner --devices --specials `  \
                                                                      `#   Which is -rlptgoD (no -H,-A,-X) `  \
                                                                      `#   No --hard-links --acls --xattrs `  \
    --fuzzy                                                           `# Attempt to detect renames.  Note that --delete-before conflicts. `  \
    --inplace                                                         `# Files on the target host are updated in the same storage the current version of the file occupies. `  \
                                                                      `#   This eliminates the need to use temp files, solving a whole shitload of issues. `  \
    --one-file-system                                                 `# Do not cross filesystem boundaries. `  \
                                                                      `#   Important in case you have bound mountpoints, e.g.  mount --bind  or in-place eCryptfs mounts. `  \
    --sparse  \
    "$directory_source/"  \
    "$directory_target/"  \
  ` # `


:<<'UNUSED'

    --checksum                                                        `# Skip based on checksum, not mod-time & size: `  \
                                                                      `#   This will copy files on the source which are modified without changes to time or size.  Some Windows logs and temp files do this. `  \
                                                                      `# Really slows things down. `  \


    --update                                                          `# Skip files that are newer on the receiver. `  \
                                                                      `#   This was leaving half-copied files if I were to control-c `  \
                                                                      `#   Seen on NTFS to ext4:  The target file only had its attributes updated after a completed copy.  Setting this switch was likely a major problem everywhere. `  \


    --delete-before                                                  `#  Deleting before doing the copying ensures that there is enough space for new files. `  \
                                                                     `#  This isn't needed if --inplace is used, since --inplace already ensures that a file can be copied overtop of the backup and that extra space for a copy-on-write is not needed. `  \


UNUSED


  if [ $? -ne 0 ]; then
    \echo  ''
    \echo  ' * ERROR'
    _teardown
    exit $?
  else
    \echo  ''
    \echo  " * rsync completed without error.."
  fi
}




_rsync_copy  "$1"  "$2"  "$3"
