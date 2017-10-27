#!/usr/bin/env  zsh



: << IDEAS
  TODO - Check out http://dotfiles.org/~brendano/.zshrc
IDEAS



{  #  Paths
  zshdir='/l/shell-random/git/live/zsh'

  PATH='/l/OS/bin':"$PATH"
  PATH="$PATH":"$zshdir/../"
  PATH="$PATH":"$zshdir/../sh/scripts"
  PATH="$PATH":"$zshdir/../bash/scripts"
  PATH="$PATH":"$zshdir/../zsh/scripts"
  # FIXME/TODO - Babun:  Tentative testing suggests there are valid applications within, but Babun is running as user.
  if [ $( \whoami ) = 'root' ]; then
    PATH="$PATH":'/sbin'
    PATH="$PATH":'/usr/sbin'
  fi
}



{  #  History
  # Keeping it out of ~/.zsh/ allows that directory's contents to be shared.
  HISTFILE="~/.zsh_histfile"
  HISTSIZE=10000
  SAVEHIST=10000
  # Neither of these work to let me prepend a command with a space and have it not commit a command to the histfile.
  #   https://www.reddit.com/r/commandline/comments/4knoj4/
  # HISTCONTROL=ignoredups:ignorespace
  # HISTCONTROL=ignoreboth
  #To save every command before it is executed (this is different from bash's history -a solution):
  \setopt  inc_append_history
  #To retrieve the history file everytime history is called upon.
  \setopt  share_history
}

# Change the highlight colour.  Underlining doesn't seem to work.
zle_highlight=(region:bg=red special:underline)

# The default:
# export  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
\export  WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

{  #  File colors
  \eval  $( \dircolors  --bourne-shell )
  # Additional archives
  \export  LS_COLORS="${LS_COLORS}":'*.7z=01;31'
  # Windows system files
  \export  LS_COLORS="${LS_COLORS}":'*.lnk=0;42'
  # Text files
  # TODO? - Can I just use a regular filename, like README ?
  \export  LS_COLORS="${LS_COLORS}":'*.txt=1;37':'*.md=1;37':'*.markdown=1;37'
  # Videos
  \export  LS_COLORS="${LS_COLORS}":'*.flv=01;35'
}


{  #  Prompt
  # A decent default prompt:
  # autoload -U promptinit && promptinit && prompt suse

  # This block lets me copy this .zshrc for the root user.
  # Test for permission.
  if [ $( \whoami ) = root ]; then
    prompt_end_color='red'
  else
    prompt_end_color='blue'
  fi



  # precmd is a zsh function which runs before a prompt.
  precmd() {
    # A vastly more complex example can be found at:
    #   http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
    # There are other solutions for things like tmux.

    if [ $( \echo  "$PWD"  |  \wc  --chars ) -lt $[($COLUMNS/2)-1] ]; then
      # This is a little odd, to allow copy-paste from whole commandlines without fucking things up.
      PS1="%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}"
    else
      # I want to display the full path, but I'm sick of starting off right at the end of a long one.
      PS1="%{$fg[black]%}\`# %{$reset_color%}%~ %{$fg_bold[$prompt_end_color]%}>%{$fg_no_bold[black]%}\`;%{$reset_color%}
    %{$fg_bold[$prompt_end_color]%}>%{$reset_color%} "
    fi
  }

  # Original, simplified, method:
  #PS1="%~ %{$fg_bold[red]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[31;1m%} > %{\e[0m%}'

  #PS1="%~ %{$fg_bold[blue]%}> %{$reset_color%}"
  #PS1=%~$'%{\e[34;1m%} > %{\e[0m%}'
}



{  # Update the title of a terminal
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
  \chpwd
}



{ # 'source' additional scripting and settings.

  function sourceallthat() {
    \pushd > /dev/null
    \cd  "$1"
    if [ -f 'lib.sh' ]; then
      \source  'lib.sh'
    fi
    for i in *.sh; do
      if [ "$i" = 'lib.sh' ]; then
        continue
      fi
      \source  "$i"
    done
    \popd > /dev/null
  }


  sourceallthat  "$zshdir/../sh/"
  sourceallthat  "$zshdir/../bash and zsh/"
  sourceallthat  "$zshdir/"

  # Cygwin / Babun
  if [ -d '/cygdrive' ]; then
    sourceallthat  "$zshdir/../babun/"
  fi

  \unset -f sourceallthat

}



# I so frequently check for disk space that I ought to do it automatically.
df



:<<'OLD'

# 2017-10-26 - Testing with this disabled.
# 
# http://www.zsh.org/mla/workers/1996/msg00191.html
if [[ $( \whoami ) = *\) ]]; then
  # We are remote
  # Do nothing
else
  DISPLAY=${DISPLAY:-:0.0}
fi



# 2017-10-26 - Babun always claims it is the tty.  I don't know when this would have been tested under Linux.
if [[ ${+WINDOWID} = 1 ]]; then
  # We're in X windows
  echo x!
else
  # We're at the tty / console
  echo tty
fi
OLD
