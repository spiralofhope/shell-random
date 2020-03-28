#!/usr/bin/env  bash
# $HOME/.bashrc



# Source global definitions
if [ -f /etc/bashrc ]; then
  # shellcheck disable=1091
  .  /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions




# I don't really care about the stuff above.  Just copy-paste it from whatever default is given.
# shellcheck disable=1090
source  "$HOME/.bashrc_mine.sh"
