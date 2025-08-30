#!/usr/bin/env  zsh
# /etc/zshenv is the 1st file zsh reads; it's read for every shell, even if started with -f (setopt NO_RCS)
# ~/.zshenv is the same, except that it's _not_ read if zsh is started with -f



_debug() {
  [ $STARTUP_DEBUG ] && echo "$*"
}



_debug  '* running ~/.zsh/1-every.sh'
# Read the profile from dash/sh:
source  ~/.profile



#  Distinguish between:
#    Cygwin
#    Linux
#    Windows Subsystem for Linux (version 1 or 2)
case "$( \uname  --kernel-name )" in
  # Cygwin / Babun
  CYGWIN*)
    this_kernel_release='Cygwin'
  ;;
  # This might be okay for git-bash
  'Linux')
    case "$( \uname  --kernel-release )" in
      *-Microsoft)
        this_kernel_release='Windows Subsystem for Linux'
      ;;
      *-microsoft-standard-WSL2)
        this_kernel_release='Windows Subsystem for Linux 2'
      ;;
      *)
        this_kernel_release='Linux'
      ;;
    esac
  ;;
  *)
    \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
  ;;
esac



if [ "$this_kernel_release" = 'Cygwin' ]; then  exit 0  ; fi


if whence -p smartctl > /dev/null  \
   &&  [ "$USER" = 'root' ]  \
   &&  [ "$this_kernel_release" = 'Linux' ]
then
  _() {
    \smartctl  --quietmode=errorsonly  --smart=on  "$1"
#    \smartctl  --smart=on  "$1"
  }
  _  '/dev/sda'
  _  '/dev/sdb'

  unset _
fi
