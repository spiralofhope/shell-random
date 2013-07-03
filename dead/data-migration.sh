#!/bin/zsh

# TODO:
# Check to make sure I'm logged in as root.

source data-migration-lib.sh

# All of this shit is useless since ntfsmount can only exclusively mount, and /dev/sdb9 will already be mounted.  Boo!
# FIXME: NEEDS TO BE REDONE FOR LUBUNTU
main() {
  processing="Migrating Windows Stuff:  ${cyan}${source} => ${dest}${reset}"
  \echo -e ""
  \echo -e "${bullet}${bullet}"
  \echo -e "${bullet}${bullet} Processing $processing"
  \echo -e "${bullet}${bullet}"
  \echo -e ""
  \echo -e "${bullet} $processing - Making the working folders..."
  \mkdir -pv /mnt/source/5/
  err $?
  \mkdir -pv /mnt/dest/9/
  err $?
  \mkdir -pv /mnt/source/9/
  err $?
  \echo -e "${bullet} $processing - Mounting source..."
  source="sda"
  element="5"
  smartmount $source $element "source"
  err $?
  \echo -e "${bullet} $processing - Mounting destination..."
  # Yes it's a "source".. I do want write access with ntfsmount so i can move the files.
  dest="sdb"
  element="9"
  smartmount $dest $element "source"
  err $?

  windows_source="/mnt/source/5/home/for-linux/"
  windows_dest="/mnt/sdb9/live/projects/working/from-windows/"
  if [ -d "$windows_source" ] && [ -d "$windows_dest" ]; then

    \echo -e "${bullet} $processing - Making the timestamped folder..."
    windows_dest="${windows_dest}`date`"
    \mkdir -pv "$windows_dest"
    err $?
    \echo -e ""
    \echo -e "${bullet}${bullet}"
    \echo -e "${bullet}${bullet} $processing - Moving the files"
    \echo -e "${bullet}${bullet}"
    \echo -e ""

    #\ls -al "${windows_source}../"
    #\ls -al "${windows_source}"
    #echo ----
    #\ls -al "$windows_dest"
    #echo ----

    # FIXME: I don't know why the fuck I can't move the contents and why I'm forced to move the whole directory.
    \mv -v "${windows_source}" "$windows_dest"
    err $?
    \mkdir "${windows_source}"
    err $?


    \echo -e "${bullet} $processing - Files moved..."
    # In case there was nothing to move.
    # TODO: Check if there are files to move in the first place.
    \rmdir --parents --ignore-fail-on-non-empty "${windows_dest}/for-linux"
    \echo -e "${bullet} $processing - Fixing permissions..."
    # I don't know if this deal with dotfiles, but those don't exist on Windows anyways.
    \find "$windows_dest" -name '*' -type d -exec \chmod 755 {} \;
    \find "$windows_dest" -name '*' -type f -exec \chmod 644 {} \;
    \chown --changes --recursive --preserve-root user:users "${windows_dest}"
    #\chown --changes user:users "${windows_dest}"
  else
    echo -e "${red}ERROR: A folder is missing!${reset}"
    echo -e "windows_source = $windows_source"
    echo -e "windows_dest = $windows_dest"
  fi

  breaktrap

  \echo -e "${bullet} $processing - Proper unmounting..."
  \echo -e "\umount /mnt/source/5"
  \umount /mnt/source/5/
  \echo -e "\umount /mnt/dest/9/"
  \umount /mnt/dest/9/
  \echo -e "${bullet} $processing - Removing the working folders..."
  # I'm not sure why I did this.
  OWD="$PWD"
  \cd /mnt
  \rmdir -pv source/5/
  \rmdir -pv dest/9/
  \cd "$OWD"
}
main
