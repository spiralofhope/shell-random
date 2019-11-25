#!/usr/bin/env  sh
# Used by other functions.
# Loaded before anything else "sh"-specific.
# Loaded before any zsh/bash content.



#:<<'}'  #  Variables
{
  # --follow-name would allow the file to be edited and less will automatically display changes.
  export  LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'

  export  PATH=\
"$(  \realpath  "$HOME/l/path" )"\
:"$( \realpath  /mnt/a/live/OS/bin )"\
:"$( \realpath  "$shdir/scripts" )"\
:"$PATH"


  #:<<'  }'   #  Distinguish between platforms
              #  - Cygwin
              #  - Linux
              #  - Windows Subsystem for Linux
  {
  case "$( \uname  --kernel-name )" in
    # Cygwin / Babun
    CYGWIN*)          export  this_kernel_release='Cygwin'  ;;
    MINGW*)           export  this_kernel_release='Mingw' ;;
    # This might be okay for git-bash:
    'Linux')
      case "$( \uname  --kernel-release )" in
        *-Microsoft)  export  this_kernel_release='Windows Subsystem for Linux' ;;
        *)            export  this_kernel_release='Linux' ;;
      esac
    ;;
    *)
      \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
    ;;
  esac
  }

  # GUI software support.
  if [ "$this_kernel_release" = 'Windows Subsystem for Linux' ]; then
    export  DISPLAY=localhost:0.0
  fi
}



#:<<'{'   #  File colors ($LS_COLORS) used for `ls`
{
  # Note that there is some serious fuckery in NTFS dealing with mount permissions and NOT dircolors!
  # I can see no solution using dircolors, and I don't know why.  This is not expected.
  # Load default dircolors:
  \eval  $( \dircolors  --bourne-shell )
  # Load manually-specified dircolors:
  __="~/.dircolors"   ;  if [ -e "$__" ]; then  \eval  $( \dircolors  --bourne-shell  "$__" )  ;  fi
  __="~/.dir_colors"  ;  if [ -e "$__" ]; then  \eval  $( \dircolors  --bourne-shell  "$__" )  ;  fi

  # Note that in order to have light blue in Windows Subsystem for Linux, you need Color Tool to enable 24-bit colors:  https://github.com/Microsoft/console/releases
  #
  # Note that *.sh isn't explicitly colored because the executable flag is preferred.

  export  LS_COLORS="${LS_COLORS}"\
:'di=0;94;40'`       # Directories `\
` # Additional archives `\
:'*.7z=01;31'\
` # Executables from other operating systems `\
:'*.bat=01;32'\
:'*.btm=01;32'`      # 4DOS/4NT `\
:'*.cmd=01;32'`      # Windows `\
:'*.com=01;32'\
:'*.exe=01;32'\
:'*.lnk=0;37'`       # Windows links.  It is not useful, so it is just being flagged like a text file. `\
` # Text files `\
:'*.doc=1;37'\
:'*.markdown=1;37'`  # markup language:  Markdown `\
:'*.md=1;37'`        # markup language:  Markdown `\
:'*.ods=1;37'`       # spreadsheet:  LibreOffice `\
:'*.pdf=1;37'\
:'*README=1;37'`     # text:  This is not  "^README$"   but this works well enough.`\
:'*.rtf=1;37'\
:'*.torrent=1;37'\
:'*.txt=1;37'\
:'*.xls=1;37'`       # spreadsheet:  Microsoft Excel `\
` #  ` > /dev/null 2>&1

# 2019-11-23
# The above redirection is to avoid errors with "#" actually trying to be executed.
#
# This is seen on Debian 64bit
#   dash  0.5.10.2-5
#   zsh   5.7.1-1
# But not Debian 32bit
#   dash  0.5.8-2.4
#   zsh   5.3.1-4+b3
# But not Windows Subsystem for Linux / Debian
#   dash  0.5.8-2.4
#   zsh   5.3.1-4+b3
#
# Future self will probably re-discover this problem, so hopefull this note helps.

}

