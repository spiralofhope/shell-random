# /etc/zshenv is the 1st file zsh reads; it's read for every shell, even if started with -f (setopt NO_RCS)
# ~/.zshenv is the same, except that it's _not_ read if zsh is started with -f



#  Distinguish between:
#    Cygwin
#    Linux
#    Windows Subsystem for Linux
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
      *)
        this_kernel_release='Linux'
      ;;
    esac
  ;;
  *)
    \echo  " * No scripting has been made for:  $( \uname  --kernel-name )"
  ;;
esac



if [ "$this_kernel_release" = 'Cygwin' ]; then ;  exit 0  ; fi



\which  smartctl > /dev/null
if [ $? -eq 0 ] && [ $( \whoami ) = 'root' ] && [ "$this_kernel_release" = 'Linux' ]; then
  __() {
    \smartctl  --quietmode=errorsonly  --smart=on  "$1"
#    \smartctl  --smart=on  "$1"
  }
  __  '/dev/sda'
  __  '/dev/sdb'

  unset __
fi
