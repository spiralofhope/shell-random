#!/usr/bin/env  sh



# Taken from zsh/colors.sh
# Expect that version there to have more functionality.
initializeANSI() {
  esc=""

  black="${esc}[30m"
  red="${esc}[31m"
  green="${esc}[32m"
  yellow="${esc}[33m"
  blue="${esc}[34m"
  purple="${esc}[35m"
  cyan="${esc}[36m"
  white="${esc}[37m"
  gray="${boldoff}${esc}[37m"
  grey="${boldoff}${esc}[37m"

  blackb="${esc}[40m"
  redb="${esc}[41m"
  greenb="${esc}[42m"
  yellowb="${esc}[43m"
  blueb="${esc}[44m"
  purpleb="${esc}[45m"
  cyanb="${esc}[46m"
  whiteb="${esc}[47m"

  boldon="${esc}[1m"
  boldoff="${esc}[22m"
  italicson="${esc}[3m"
  italicsoff="${esc}[23m"
  ulon="${esc}[4m"
  uloff="${esc}[24m"
  invon="${esc}[7m"
  invoff="${esc}[27m"

  black_bold="${boldon}${esc}[30m"
  red_bold="${boldon}${esc}[31m"
  green_bold="${boldon}${esc}[32m"
  yellow_bold="${boldon}${esc}[33m"
  blue_bold="${boldon}${esc}[34m"
  purple_bold="${boldon}${esc}[35m"
  cyan_bold="${boldon}${esc}[36m"
  white_bold="${boldon}${esc}[37m"

  reset="${esc}[0m"

  cursor_position_save="\033[s"
  cursor_position_restore="\033[u"
}
initializeANSI



be_root_or_die() {
  if [ $(whoami) != "root" ]; then
    \echo "ERROR:  You're not root!"
    exit 1
  fi
}


