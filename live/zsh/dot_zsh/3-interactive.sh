#!/usr/bin/env  zsh
# shellcheck disable=1012
# shellcheck disable=1001
# ~/.zshrc

:<<'}'   #  Notes
{
  man zshoptions

  TODO - Check out http://dotfiles.org/~brendano/.zshrc
}


#   $HOME is set automatically somewhere; I don't know where.
# For 32bit Debian, I have to manually do this..
# Commented-out, because this is already run by 2-login.sh
# shellcheck disable=1090
#.  "$HOME/.profile"


#:<<'}'  #  Variables
{
  # It really isn't quite right to leverage the existence of ~/.zshrc like this, but it works for my setup.
  zshdir="$( \realpath  /home/user/.zshrc )"
  zshdir="$( \dirname "$( \dirname "$zshdir" )" )"
  zshdir="$( \realpath "$zshdir" )"
  if ! [ -d "$zshdir" ]; then
    \echo  "\$zshdir is not a directory:  $zshdir"
    return  1
  fi
}


{  # 'source' additional scripting and settings.

  sourceallthat() {
    #\echo  "sourcing $1"
    # zshism
    # shellcheck disable=2039
    \pushd > /dev/null  ||  return
    \cd  "$1"  ||  return
    # shellcheck disable=1091
    # zshism
    # shellcheck disable=2039
    if [ -f 'lib.sh' ]; then  .  ./'lib.sh';  fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then continue; fi
      # shellcheck disable=1090
      # zshism
      # shellcheck disable=2039
      .  ./"$i"
    done
    # Note that it's intentional that this will generate an error if  suu()  is called by root, when root is currently sitting in an directory that denies permission to the user.
    # zshism
    # shellcheck disable=2039
    \popd > /dev/null  ||  return
  }


  sourceallthat  "$zshdir/functions/"
  sourceallthat  "$zshdir/"


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
      .  "$zshdir/../wfl/lib.sh"
      # shellcheck disable=1090
      # zshism
      # shellcheck disable=2039
      .  "$zshdir/../wfl/aliases.sh"
    ;;
  esac


  \unset  -f sourceallthat

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
  }
  #chpwd
}



{  #  Paths

  # Note that these backslashes must not have a space preceeding them, as would normally be my scripting style.
  PATH=\
"$(  \realpath  "$zshdir/scripts" )"\
:"$( \realpath  "$zshdir/../bash/scripts" )"\
:"$PATH"

  if [ "$this_kernel_release" = 'Cygwin' ]  \
  || [ "$this_kernel_release" = 'Windows Subsystem for Linux' ]  \
  || [ "$this_kernel_release" = 'Windows Subsystem for Linux 2' ]  \
  ; then
    PATH=\
"$( \realpath  "$zshdir/../wfl/scripts" )"\
:"$PATH"
    fi

:<<'}'  #  Not used/tested in a while..
{
  # FIXME/TODO - Babun:  Tentative testing suggests there are valid applications within, but Babun is running as user.
  if [ "$USER" = 'root' ]; then
    PATH="$PATH":'/sbin'
    PATH="$PATH":'/usr/sbin'
  fi
}
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
