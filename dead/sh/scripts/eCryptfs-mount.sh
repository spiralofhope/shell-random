#!/bin/sh


# ecryptfs mount helper
#   http://ecryptfs.org/
# Because it's annoying to remember this shit.


if ! [ -d "$*" ]; then
  \echo  " * That directory doesn't exist, making it.."
  \mkdir  --verbose  "$*"
fi

# $* is the name of the directory

# This works for
#   - creating a new encrypted folder
#   - mounting an existing encrypted folder
# \sudo \
/bin/su  --command "\
  mount  -t ecryptfs \
    \"$*\"  \"$*\" \
    ` # Ask for the user to type in a password ` \
    -o key=passphrase \
    -o ecryptfs_cipher=aes \
    -o ecryptfs_enable_filename_crypto \
    -o ecryptfs_key_bytes=32 \
    -o ecryptfs_passthrough=n \
"` # `
