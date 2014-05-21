# TODO? - separate the archives of the settings and the addons

: <<NOTES
DO NOT USE the 7-zip format for backup purpose on Linux/Unix because :
 - 7-zip does not store the owner/group of the file.

On Linux/Unix, in order to backup directories you must use tar :
 - to backup a directory  : tar cf - directory | 7za a -si directory.tar.7z
 - to restore your backup : 7za x -so directory.tar.7z | tar xf -
NOTES



# date=$(\date --date='%F-%T')
date=$( \date +%Y-%m-%d--%H-%M-%S )
_tar=/mnt/320-data/wow-backups
_wow=/mnt/ssd-data/wow



_wtf() {
  local  source=$_wow/_game/WTF/*
  local  target=$_tar/settings/WTF--${date}.7z
  \7z  a  -mx=9  -r  $target  $source
  \ls  --all  -l   $target
}



_interface() {
  local  source=$_wow/_game/Interface/*
  local  target=$_tar/addons/Interface--${date}.7z
  \7z  a  -mx=9  -r  $target  $source
  \ls  --all  -l  $target
}



_wtf
_interface
