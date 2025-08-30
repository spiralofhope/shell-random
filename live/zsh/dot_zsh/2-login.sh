#!/usr/bin/env  zsh
# /etc/zprofile and ~/.zprofile
# Read after zshenv, if the shell is a login shell.



_debug() {
  [ $STARTUP_DEBUG ] && echo "$*"
}



_debug  '* running ~/.zsh/2-login.sh'
