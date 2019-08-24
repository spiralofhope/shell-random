#!/bin/sh

# TODO - automate this more.. check out my other notes, from other projects..

# dir must begin with a slash.
user=pi
host=192.168.0.2
source_dir=/source/
target_dir=/target/


\mkdir  --parents  $target_dir


_lftp() {
  \lftp \
    sftp://${user}@${host}${source_dir} \
  ` # `
}



_rsync() {
  \rsync  -avz  --progress  ${user}@${host}:${source_dir} $target_dir
}


#_lftp
_rsync
