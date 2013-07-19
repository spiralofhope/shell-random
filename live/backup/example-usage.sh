#!/bin/false

# --
# -- USAGE
# --

# ./backup.sh \
#   [source  UUID|sdx|directory] \
#   [target  UUID|sdx|directory] \

# The source and the target can refer to anything you like.
# UUID      [recommended]
# /dev/sdx  [dangerous!]
# directory [be careful]

# UUID
# See  /dev/disk/by-uuid  to determine the UUID based on  `/dev/sdx`
 
# /dev/sdx
# The last thing you want to do is accidentally overwrite the contents of an entire partition because you added or removed a drive and the letters shifted.  Reusable scripts should refer to the UUID to be safe.

# directory
# When using a directory, you may want to have it in your backup.rsync-exclude-list.txt
# End your directory reference with a slash.



# --
# -- CONFIGURATION
# --

# For rsync to not actually write or delete files.
# This is essential for testing!
#dry_run=--dry-run

# Additional output, for troubleshooting.  I like to leave it on, just in case.
print_teardown_info='true'



# --
# -- EXAMPLES
# --

# Copy from one partition to another.  Identifying by UUID.
./backup.sh \
  ` # sda1 ` \
  9b0bc44a-d8c1-4630-be6d-da90a1f311d7 \
  ` # sdb5 ` \
  0d94abe1-9439-491a-8ddd-7558ccf5ede1 \
  ` # `

# Instead of the UUID, you can use the  `/dev/sdx`  form.
./backup.sh  /dev/sda1  /dev/sdb1

# You can make the target a directory.  End with a slash.
./backup.sh  /dev/sda1  /path/to/target-directory/

# You can make the source and target a directory.  End with a slash.
# This is somewhat pointless, as you could have just used  `rsync`  directly.
./backup.sh  /path/to/source-directory/  /path/to/target-directory/

# The target can be a partition.
# The entire contents of that partition will be synchronized with that directory.  So you will obliterate everything in it if you screw up.
./backup.sh  /path/to/source-directory/  /dev/sdb1



# TODO (code/example, see my run/terminal scripts) - if you want to perform multiple backups, and you want to stop between them, then you can check $? and act appropriately.

# TODO (find my notes) - output logging
