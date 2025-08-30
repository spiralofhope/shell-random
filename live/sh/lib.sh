#!/usr/bin/env  sh
# Used by other functions.
# Loaded before anything else "sh"-specific.
# Loaded before any zsh/bash content.



_debug() {
  [ $STARTUP_DEBUG ] && echo "$*"
}



_debug  '* running sh/lib.sh'



#:<<'}'  #  Variables
{
  # --follow-name would allow the file to be edited and less will automatically display changes.
  LESS=' --force  --ignore-case  --long-prompt  --no-init  --quit-at-eof  --quit-if-one-screen  --raw-control-chars  --silent  --tilde  --window=-2'
  #LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'
  export  LESS


  prepend_path() {
    #PATH="$( \realpath "$1" ):$PATH"
    PATH="${1}:$PATH"
  }


  prepend_path  "$HOME/l/path"
  #prepend_path  '/mnt/a/live/OS/bin'
  # $shdir is set in ~/.profile
  prepend_path  "${shdir:?}/scripts"


  deduplicate_path() {
    unique_path=''
    for dir in $( \echo "$PATH" | \tr ':' '\n' ); do
      # Check if dir is already in unique_path:
      case ":$unique_path:" in
        *":$dir:"*) ;;  #  Do nothing if already included
        *) unique_path="${unique_path:+$unique_path:}$dir" ;;
      esac
    done
    PATH="$unique_path"
  }
  deduplicate_path



:<<'}'
{
  PATH=\
-"$(  \realpath  "$HOME/l/path" )"\
:"$( \realpath  /mnt/a/live/OS/bin )"\
:"$( \realpath  "${shdir:?}/scripts" )"\
:"$PATH"
  export  PATH
}


  #:<<'  }'   #  Distinguish between platforms
              #  - Cygwin
              #  - Linux
              #  - Windows Subsystem for Linux
  {
  case "$( \uname  --kernel-name )" in
    # Cygwin / Babun
    CYGWIN*)          this_kernel_release='Cygwin' ;;
    MINGW*)           this_kernel_release='Mingw' ;;
    # This might be okay for git-bash:
    'Linux')
      case  "$( \uname  --kernel-release )" in
        *-Microsoft)  this_kernel_release='Windows Subsystem for Linux'  ;;
        *)            this_kernel_release='Linux'  ;;
      esac
    ;;
    *)
      \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
    ;;
  esac
  export  this_kernel_release
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
  \eval  "$( \dircolors  --bourne-shell )"
  # Load manually-specified dircolors:
  _="$HOME/.dircolors"   ;  if [ -e "$_" ]; then  \eval  "$( \dircolors  --bourne-shell  "$_" )"  ;  fi
  _="$HOME/.dir_colors"  ;  if [ -e "$_" ]; then  \eval  "$( \dircolors  --bourne-shell  "$_" )"  ;  fi

  # Note that in order to have light blue in Windows Subsystem for Linux, you need Color Tool to enable 24-bit colors:  https://github.com/Microsoft/console/releases
  #
  # Note that *.sh isn't explicitly colored because the executable flag is preferred.


  _(){
    LS_COLORS="${LS_COLORS}:${1}"
  }

  _ "di=0;94;40"   # Directories
  # Additional archives
  _ "*.7z=01;31"  # 7zip
  # Executables from other operating systems
  _ "*.bat=01;32"
  _ "*.btm=01;32"   # 4DOS/4NT
  _ "*.cmd=01;32"   # Windows
  _ "*.com=01;32"
  _ "*.exe=01;32"
  # Text files
  _ "*.doc=1;37"
  _ "*.lnk=0;37"
  _ "*.markdown=1;37"  # Markdown markup language
  _ "*.md=1;37"        # Markdown markup language
  _ "*README=1;37"  # I'd prefer  "^README$"  but this works well enough.
  _ "*.torrent=1;37"
  _ "*.txt=1;37"
  # Binary documents
  _ "*.ods=1;37"  # LibreOffice Calc
  _ "*.pdf=1;37"
  _ "*.rtf=1;37"
  _ "*.xls=1;37"  # Microsoft Excel
  export  LS_COLORS

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

