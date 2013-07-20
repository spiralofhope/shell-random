#!/usr/bin/env  bash

# --
# -- CONFIGURATION
# --

# You can delete the existing symbolic link  `backup-configuration.sh`
# and copy this overtop.


# For rsync to not actually write or delete files.
# This is essential for testing!
#dry_run=--dry-run

# In my case, this is generated when 'btrfs-tools' is not available.
#ignore_fsck_error_8='true'

# Additional output, for troubleshooting.  I like to leave it on, just in case.
print_teardown_info='true'
