#!/usr/bin/env  sh
# shellcheck disable=2034



:<<'}'   #  UPDATE:  There is actual functionality hidden away.
{
  \tput  setaf  1
  \echo  'This is red'
  \tput  sgr0
  \echo  'This is back to normal'

  for i in {1..256}; do
    \tput  setaf  $i
    echo -n "$i"\ 
  done
  \tput  sgr0
}



# This was also integrated into backup/backup-lib.sh, but expect this
# script here to have more functionality.

# http://www.intuitive.com/wicked/showscript.cgi?011-colors.sh
# ANSI Color -- use these variables to easily have different color
#    and format output. Make sure to output the reset sequence after
#    colors (f = foreground, b = background), and use the 'off'
#    feature for anything you turn on.


:<<'}'   #  git-bash:  ANSI under Windows
Use ANSICON
  https://blog.spiralofhope.com/?p=37580
  http://ansicon.adoxa.vze.com/
  https://github.com/adoxa/ansicon/releases/latest
on Windows 10:
  1. unzip it somewhere.
  2. open a cmd as admin
       windows-x a
  3. go to its unzipped location, to x64
  4. ansicon.exe -I
}



initializeANSI() {

  # Various ways to reference byte 27:
  #ANSI_escape_code=''
  #ANSI_escape_code='\x1b'
  #ANSI_escape_code='\e'
  #ANSI_escape_code='\033'
  {   #  Determine what sort of machine we're on
    unameOut="$( \uname  --kernel-name )"
    case "${unameOut}" in
      CYGWIN*)    machine=Cygwin;;
      Darwin*)    machine=Mac;;
      Linux*)     machine=Linux;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
    esac
    #echo ${machine}

    case "${unameOut}" in
      # Babun
      CYGWIN*)
        ANSI_escape_code=''
      ;;
      # This might be okay for git-bash
      MINGW*|'Linux')
        # 2022-04-09 - This isn't working for dash any more, if it ever did.
        #ANSI_escape_code='\033'
        ANSI_escape_code=''
      ;;
      *)
        ANSI_escape_code=''
      ;;
    esac
  }
Disable the autowrap feature.
#ANSI_escape_code='[?7l'

  # Foreground colour
  black="${ANSI_escape_code}[30m"
  red="${ANSI_escape_code}[31m"
  green="${ANSI_escape_code}[32m"
  yellow="${ANSI_escape_code}[33m"
  blue="${ANSI_escape_code}[34m"
  purple="${ANSI_escape_code}[35m"
  cyan="${ANSI_escape_code}[36m"
  white="${ANSI_escape_code}[37m"
  gray="${boldoff}${ANSI_escape_code}[37m"
  grey="${boldoff}${ANSI_escape_code}[37m"

  # Background colour
  blackb="${ANSI_escape_code}[40m"
  redb="${ANSI_escape_code}[41m"
  greenb="${ANSI_escape_code}[42m"
  yellowb="${ANSI_escape_code}[43m"
  blueb="${ANSI_escape_code}[44m"
  purpleb="${ANSI_escape_code}[45m"
  cyanb="${ANSI_escape_code}[46m"
  whiteb="${ANSI_escape_code}[47m"

  boldon="${ANSI_escape_code}[1m"
  boldoff="${ANSI_escape_code}[22m"
  italicson="${ANSI_escape_code}[3m"
  italicsoff="${ANSI_escape_code}[23m"
  ulon="${ANSI_escape_code}[4m"
  uloff="${ANSI_escape_code}[24m"
  invon="${ANSI_escape_code}[7m"
  invoff="${ANSI_escape_code}[27m"

  # Foreground colour, bolded
  black_bold="${boldon}${ANSI_escape_code}${black}"
  red_bold="${boldon}${ANSI_escape_code}${red}"
  green_bold="${boldon}${ANSI_escape_code}${green}"
  yellow_bold="${boldon}${ANSI_escape_code}${yellow}"
  blue_bold="${boldon}${ANSI_escape_code}${blue}"
  purple_bold="${boldon}${ANSI_escape_code}${purple}"
  cyan_bold="${boldon}${ANSI_escape_code}${cyan}"
  white_bold="${boldon}${ANSI_escape_code}${white}"

  reset_color="${ANSI_escape_code}[0m"

  cursor_position_save='${ANSI_escape_code}[s'
  cursor_position_restore='${ANSI_escape_code}[u'
}
initializeANSI



:<< '}'   #  Testing
{
  \echo  "${yellow}This is a phrase in yellow${redb} and red"
  \echo  -n  "${reset_color}"
  \echo  "${ulon}This is underlined${uloff} and this is not"
  \echo  "${boldon}This is bold${boldoff} and this is not"
  \echo  "${italicson}This is italics${italicsoff} and this is not"
  \echo  "${ulon}This is ul${uloff} and this is not"
  \echo  "${invon}This is inv${invoff} and this is not"
  \echo  "${yellow}${redb}Warning I ${yellowb}${red}Warning II"
  \echo  -n  "${reset_color}"
}
