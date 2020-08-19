#!/usr/bin/env  sh

# Download just a YouTube video's skeleton; no video:
#   -  General info
#   -  Thumbnail
#   -  Description
#   -  Comments



youtube_download_skeleton() {
  # Set the terminal title
  \printf  '\033]0;...\007'
  \youtube-download.sh  "$@"  --skip-download
  # Restore the terminal title
  \cd  .  ||  return  $?
}
