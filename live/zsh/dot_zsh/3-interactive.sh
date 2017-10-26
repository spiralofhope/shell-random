: << IDEAS
  TODO - Check out http://dotfiles.org/~brendano/.zshrc
IDEAS


zshdir=/l/shell-random/git/live/zsh

PATH=/l/OS/bin:$PATH
PATH=$PATH:/l/shell-random/git/live
PATH=$PATH:/l/shell-random/git/live/sh/scripts
PATH=$PATH:/l/shell-random/git/live/bash/scripts
PATH=$PATH:/l/shell-random/git/live/zsh/scripts
if [ $( \whoami ) = root ]; then
  PATH=$PATH:/sbin
  PATH=$PATH:/usr/sbin
else
  # do nothing
fi

# Keeping it out of ~/.zsh/ allows that directory's contents to be shared.
HISTFILE=
HISTFILE=~/.zsh_histfile
HISTSIZE=10000
SAVEHIST=10000
# Neither of these work to let me prepend a command with a space and have it not commit a command to the histfile.
#   https://www.reddit.com/r/commandline/comments/4knoj4/
# HISTCONTROL=ignoredups:ignorespace
# HISTCONTROL=ignoreboth
#To save every command before it is executed (this is different from bash's history -a solution):
setopt inc_append_history
#To retrieve the history file everytime history is called upon.
setopt share_history

# Change the highlight colour.  Underlining doesn't seem to work.
zle_highlight=(region:bg=red special:underline)

# The default:
# export  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
export  WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

eval  $( dircolors -b )
export  LS_COLORS=${LS_COLORS}":*.7z=01;31"



# Prompt
# This block lets me copy my .zsh for the root user.
# Test for permission.
if [ $( \whoami ) = root ]; then
  local  _my_color=red
else
  local  _my_color=blue
fi



# precmd is a zsh function which runs before a prompt.
precmd() {
  # A vastly more complex example can be found at:
  #   http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
  # There are other solutions for things like tmux.

  if [ $( \echo  "$PWD"  |  \wc  --chars ) -lt $[($COLUMNS/2)-1] ]; then
  # This is a little odd, to allow copy-paste from whole commandlines without fucking things up.
    PS1="%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$_my_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}"
  else
  # I want to display the full path, but I'm sick of starting off right at the end of a long one.
    PS1="%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$_my_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}
  %{$fg_bold[$_my_color]%}>%{$reset_color%} "
  fi
}



# Inserting a raw ANSI code is probably easier, but I have no clue how.
#   go_back_two_characters = $( \echo "\033[2D" )

#PS1="%~ %{$fg_bold[red]%}> %{$reset_color%}"
#PS1=%~$'%{\e[31;1m%} > %{\e[0m%}'

#PS1="%~ %{$fg_bold[blue]%}> %{$reset_color%}"
#PS1=%~$'%{\e[34;1m%} > %{\e[0m%}'

# A decent default prompt:
# autoload -U promptinit && promptinit && prompt suse


# Update the title of a terminal
chpwd() {
  [[ -t 1 ]] || return
  case $TERM in
    sun-cmd)
      print -Pn "\e]l%~\e\\"
    ;;
    *xterm*|rxvt(-unicode)|(dt|k|E)term|screen)
      print -Pn "\e]2;%~\a"
    ;;
  esac
}
chpwd



# http://www.zsh.org/mla/workers/1996/msg00191.html
if [[ $( \whoami ) = *\) ]]; then
  # We are remote
  # Do nothing
else
  DISPLAY=${DISPLAY:-:0.0}
fi

#if [[ ${+WINDOWID} = 1 ]]; then
  ## We're in X windows
#else
  ## We're at the tty / console
#fi



# This loads RVM into a shell session.
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Ruby Version Manager
#if [ $( \whoami ) = root ]; then
#else
#  rvm use 1.9.2 >> /dev/null
#fi



# Load additional scripting and settings.

# Apparently I can't source wildcards on:
#   zsh 5.0.2 (x86_64-pc-linux-gnu)
# e.g.
#   source  "$zshdir"/*.sh
# .. because it messes up colours.sh, for some reason.

source  "$zshdir/../bash and zsh"/lib.sh

for i in "$zshdir/../bash and zsh"/*.sh; do
  if [ $i = "$zshdir/../bash and zsh"/lib.sh ]; then
    continue
  fi
  source  "$i"
done

source  "$zshdir"/lib.sh

for i in "$zshdir"/*.sh; do
  # skip my working file..
#   if [ ! "$i" = "/home/user/bin/zsh/temp.sh" ]; then source $i ; fi
  if [ $i = $zshdir/lib.sh ]; then
    continue
  fi
  source  "$i"
done



# I so frequently check for disk space that I ought to do it automatically.
if [ "$PWD" == "$HOME" ]; then
  # Using the fancy df alias
  df
  \echo
fi


if [ -d '/cygwin' ]; then
  for i in "$zshdir/../babun"/*.sh; do
    \source  "$i"
  done
fi
