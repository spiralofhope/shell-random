#!/usr/bin/env  zsh
# shellcheck disable=1012
# shellcheck disable=1001
# ~/.zshrc



_debug() {
  [ $STARTUP_DEBUG ] && echo "$*"
}



_debug  '* running ~/.zsh/3-interactive.sh'


:<<'}'   #  Notes
{
  man zshoptions

  TODO - Check out http://dotfiles.org/~brendano/.zshrc
}


#:<<'}'   #  There is also  `replace-dirname.sh`
_zsh_dirname() {
  local dir=${1:-.}
  local var_name=$2
  dir=${dir:h}
  [[ -z $dir ]] && dir=/
  typeset -g "$var_name=$dir"
}


_zsh_realpath() {
  local file=$1 var_name=$2
  typeset -g "$var_name=${file:A}"
}
  _zsh_realpath '/home/user/.zshrc' zshdir



# 2-login.sh should be running this already:
:<<'}'
{
if [ ! "$shdir" = '' ]; then
  # shellcheck disable=1090
  # $HOME is automatically set somewhere; I don't know where.
  # For 32bit Debian, I have to manually do this:
  # This is already supposed to be run by 2-login.sh but might not be!
  .  "$HOME/.profile"
fi
}
#  .  "$HOME/.profile"



#:<<'}'  #  Variables
{
  # It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
  _zsh_realpath '/home/user/.zshrc' zshdir
  _zsh_dirname "$zshdir" zshdir
  _zsh_dirname "$zshdir" zshdir
  if ! [ -d "$zshdir" ]; then
    \echo  "\$zshdir is not a directory:  $zshdir"
    return  1
  fi
}


_='3-interactive.sh'
# Taken directly from .profile
{  # 'source' additional scripting and settings.
  _pushd="$PWD"
  _sourceallthat() {
    \cd  "$1"  ||  return  $?
    for i in *.sh; do
      _debug  "... $_ is sourcing $PWD/$i"
      # shellcheck disable=1090
      .  ./"$i"
      #if $STARTUP_DEBUG; then
        #.  ./"$i"
      #else
        #.  ./"$i"   > /dev/null  2> /dev/null
      #fi
    done
  }

  .  "$zshdir/lib.sh"
  _sourceallthat  "$zshdir/functions/"
  _sourceallthat  "$zshdir/"
  \cd  "$_pushd"  ||  return  $?
  \unset      _pushd
  \unset  -f  _sourceallthat
}



{
  case "${this_kernel_release:?}" in
    'Cygwin')
      sourceallthat  "$zshdir/../babun/"
    ;;
    'Windows Subsystem for Linux'|'Windows Subsystem for Linux 2')
      # I don't understand why doing this will change the directory I'm dropped into:
      #sourceallthat  "$zshdir/../wfl/"
      # shellcheck disable=1090
      # zshism
      # shellcheck disable=2039
      _debug  "... 3-interactive.sh is sourcing $zshdir/../wfl/lib.sh"
      .  "$zshdir/../wfl/lib.sh"
      # shellcheck disable=1090
      # zshism
      # shellcheck disable=2039
      _debug  "... 3-interactive.sh is sourcing $zshdir/../wfl/aliases.sh"
      .  "$zshdir/../wfl/aliases.sh"
    ;;
  esac
}



{  #  History
  # Keeping it out of ~/.zsh/ allows that directory's contents to be shared online.
  HISTFILE="$HOME/.zsh_histfile"  ;  export  HISTFILE
  HISTSIZE=10000                  ;  export  HISTSIZE
  SAVEHIST=10000                  ;  export  SAVEHIST
  # prepend a command with a space and have it not commit a command to $HISTFILE ($HOME/.zsh_histfile)
  setopt  HIST_IGNORE_SPACE
  # Disable history expansion using "!" so that things like this work to clobber contents:
  #   \echo  'text to clobber with'  >!  'filename.ext'
  set  +H
}


# Change the highlight colour.  Underlining doesn't seem to work.
# zshism
# shellcheck disable=2039
# shellcheck disable=2191
zle_highlight=(region:bg=red special:underline)  ;  export  zle_highlight

# The default:
# WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'  ;  export  WORDCHARS


# Report the time used for any command that takes longer than n seconds.
REPORTTIME=10


# shellcheck disable=1039
#   allow the comment
#:<<'}'   #  Prompt
{
  # A decent default prompt:
  # autoload -U promptinit && promptinit && prompt suse

  # Original, simplified, method:
  #PS1="%~ %{$fg_bold[red]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[31;1m%} > %{\e[0m%}'
  #PS1="%~ %{$fg_bold[blue]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[34;1m%} > %{\e[0m%}'

  # This block lets me copy this .zshrc for the root user.
  # Test for permission.
  # shellcheck disable=2034
  if [ "$USER" = 'root' ];
    then  prompt_end_color='red'
    else  prompt_end_color='blue'
  fi

  :<<'  }'  #  Obsoleted
  # Devuan and Windows Subsystem for Linux 2 both work with the sh prompt and long prompt code
  precmd() {
    # precmd() is a zsh function which runs before a prompt.
    # A vastly more complex example can be found at:
    #   http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
    # There are other solutions for things like tmux.
    if [ ${#PWD} -lt $(( ( COLUMNS / 2 ) - 1 )) ]; then
      # This is a little odd, to allow copy-paste from whole commandlines without fucking things up.
      # zshism?
      # shellcheck disable=1087
      # shellcheck disable=2154
      PS1="%{$reset_color%}%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}"
    else
      # I want to display the full path, but I'm sick of starting off right at the end of a long one.
      # zshism?
      # shellcheck disable=1087
      # zshism?
      # shellcheck disable=1083
      PS1="%{$reset_color%}%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}%{$fg_bold[$prompt_end_color]%}>%{$reset_color%} "
    fi
  }

}



{  #  Update the title of a terminal
  preexec() { \print  -Pn  "\e]0;%~ - $1\a" }
  chpwd() {   \print  -Pn  "\e]0;%~ - $1\a" }
  chpwd

  #chpwd() {
    #[ -t 1 ]  ||  return
    #\print  -Pn  "\e]2;%~\a"
  #}
  :<<'  }'   # I don't think I've ever needed this complexity
  {
    chpwd() {
      [ -t 1 ]  ||  return
      case  "$TERM"  in
        sun-cmd)
          print  -Pn  "\e]l%~\e\\"
        ;;
        *xterm*|rxvt(-unicode)|(dt|k|E)term|screen)
          print  -Pn  "\e]2;%~\a"
        ;;
      esac
    }
  chpwd
  }
}



#:<<'}'   #  Paths
{
  # Note that these backslashes must not have a space preceeding them, nor must the following lines have spaces, as would normally be my scripting style.  Must end with a blank line.
  PATH=\
"$PATH"\
:"$zshdir/scripts"\
:"$zshdir/../bash/scripts"\
:'/home/user/.local/bin'\

  if [ "$this_kernel_release" = 'Cygwin' ]  \
  || [ "$this_kernel_release" = 'Windows Subsystem for Linux' ]  \
  || [ "$this_kernel_release" = 'Windows Subsystem for Linux 2' ]  \
  ; then
    PATH=\
"$zshdir/../wfl/scripts"\
:"$PATH"
    fi
  export  PATH
}



:<<'}'   #  Various zshoptions:  `setopt`
{
  # Documentation:
  #   man zshoptions
  # Experiment by removing everything first.
  # (Do this at the commandline, not through this script)
  # I'm not sure why I can't use the ${} style:
  #   for i in `setopt`; do unsetopt "$i"; done
}


# Syntax highlighting magic
#   https://github.com/zsh-users/zsh-syntax-highlighting
#FIXME - a smarter path
# zshism:
# shellcheck disable=1091
# shellcheck disable=2039
_='/live/OS/bin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if [ -f "$_" ]; then
  \source  "$_"
fi
_='/mnt/c/vaulted_c/Sync/OS/WSL2/bin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if [ -f "$_" ]; then
  \source  "$_"
fi



# I so frequently check for disk space that I ought to do it automatically.
# Note this is not  \dd  because I prefer my customized `_df()` from `live/sh/functions/df.sh`
df



# ---------------------------------------------------------------------


:<<'}'
{
# 2017-10-26 - Babun always claims it is the tty.  I don't know when this would have been tested under Linux.
if [[ ${+WINDOWID} = 1 ]]; then
  # We're in X windows
  echo x!
else
  # We're at the tty / console
  echo tty
fi
}



:<<'}'
{
if [ -d '/mnt/a' ]; then  local  c_drive='/mnt/a'; fi   # Windows Subsystem for Linux
if [ -d '/mnt/c' ]; then  local  c_drive='/mnt/c'; fi   #
if [ -d '/mnt/d' ]; then  local  d_drive='/mnt/d'; fi   #
if [ -d '/a' ];     then  local  c_drive='/a';     fi   # Babun
if [ -d '/c' ];     then  local  c_drive='/c';     fi   #
if [ -d '/d' ];     then  local  d_drive='/d';     fi   #
}
