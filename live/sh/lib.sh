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
    # This might be okay for git-bash
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
  # Load defaults:
  \eval  $( \dircolors  --bourne-shell )
  {   # Load custom dircolors
    __="~/.dircolors"   ;  if [ -e "$__" ]; then  \eval  $( \dircolors  --bourne-shell  "$__" )  ;  fi
    __="~/.dir_colors"  ;  if [ -e "$__" ]; then  \eval  $( \dircolors  --bourne-shell  "$__" )  ;  fi
  }
  # Directories
  # 94 = text, light blue
  # 40 = background, black
  # Note that in order to have light blue in Windows Subsystem for Linux, you need Color Tool to enable 24-bit colors:  https://github.com/Microsoft/console/releases

# Do note that .sh isn't explicitly colored because the executable flag is preferred.

\export  LS_COLORS="${LS_COLORS}"\
:'di=0;94;40'\
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
`  # Videos `\
:'*.flv=01;35'\
` # `
}



