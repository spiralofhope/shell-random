# bash-windows, tested 2016-05-13 on Windows 10, updated recently.
# GNU bash, version 4.3.42(5)-release (x86_64-pc-msys)


# --
# TODO
# --
# be able to ls|less and keep color
# clean up /c/l/live/shell-random/git/dead/bash/ and don't forget to export it into the 1 shell-random/git
# TODO - export all of this into a more current configuration setup.


# Setting up a tmpfs.  This also works on Windows (msysgit)
# mkdir -p $HOME/tmp
# sudo mount -t tmpfs -o size=10G tmpfs $HOME/tmp
# cd $HOME/tmp



# --
# GIT BASH QUIRKS
# --
# (nothing noted yet)



# --
# -- General settings
# --
export  GIT_DIRECTORY='/c/l/live/Git_For_Windows'
export  shell_random='/c/l/live/shell-random/git'
export  PATH="${PATH}:${GIT_DIRECTORY}/bin"
export  PATH="${PATH}:$shell_random/live/"
export  PATH="${PATH}:$shell_random/live/sh/scripts/"
export  PATH="${PATH}:$shell_random/live/bash-windows/scripts/"
PF='/c/Program\ Files'
PFx="${PF}\ \(x86\)"



# --
# -- Tab completion
# --

set show-all-if-ambiguous on 
set completion-ignore-case on

# Pressing tab immediately suggests the full command line.
# When the user types something partial, pressing tab immediately cycles through suggested matches.
bind  '"\t":  menu-complete'
# TODO - Explore shift-tab to go backwards in history
# TODO - Explore tab also listing the possible matches
# TODO - Explore listing the possible matches as one single-column where possible.  There's nothing built-in, but it's possible to associate a method to the completion functionality.



# --
# -- TODO - control-left/right
# --
#bind "\e[1;5C": forward-word
#bind "\e[1;5D": backward-word
#bind "\e[5C": forward-word
#bind "\e[5D": backward-word
#bind "\e\e[C": forward-word
#bind "\e\e[D": backward-word
#bind '"\e\x5b\x31\x3b\x35\x44"':backward-word
#bind '"\e\x5b\x31\x3b\x35\x43"':forward-word


# --
# -- TODO - Page up / Page down to go through history
# --

# bind -P  will display the list of bindings
# These seem to be default.
# arrow up
#bind  "\e[5~":  history-search-backward
# arrow down
#bind  "\e[B":   history-search-forward

# TODO - I can't figure out how to use pageup/pagedown
# page up
#bind  "\e[A":   history-search-backward
# page down
#bind  "\e[6~":  history-search-forward
#bind "\e[A": history-search-backward
# fucks up the use of 'b'
#bind "\e[B": history-search-forward
#bind '"\e[A":history-search-backward'
#bind '"\e[B":history-search-forward'

#bind  "\e[A":   previous-history
#bind  "\e[6~":      next-history


# --
# -- Other stuff
# --
set  dirspell  on



# Default
# LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export  LS_COLORS="di=01;36"
export  LS_COLORS=${LS_COLORS}':*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.tex=01;33:*.sxw=01;33:*.sxc=01;33:*.lyx=01;33:*.pdf=0;35:*.ps=00;36:*.asm=1;33:*.S=0;33:*.s=0;33:*.h=0;31:*.c=0;35:*.cxx=0;35:*.cc=0;35:*.C=0;35:*.o=1;30:*.am=1;33:*.py=0;34'
# --
# My additions
# --
# Additional archives
export  LS_COLORS=${LS_COLORS}':*.7z=01;31'
# Windows system files
export  LS_COLORS=${LS_COLORS}':*.lnk=0;42'
# Text files
export  LS_COLORS=${LS_COLORS}':*.txt=1;37:*.markdown=1;37'



#-------------
# taken from my ancient stuff
#-------------

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# TODO - this doesn't work.  Should I be doing something within PROMPT_COMMAND ?
shopt -s checkwinsize


esc=""

# Foreground colour
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

# Background colour
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

# Foreground colour, bolded
black_bold="${boldon}${esc}[30m"
red_bold="${boldon}${esc}[31m"
green_bold="${boldon}${esc}[32m"
yellow_bold="${boldon}${esc}[33m"
blue_bold="${boldon}${esc}[34m"
purple_bold="${boldon}${esc}[35m"
cyan_bold="${boldon}${esc}[36m"
white_bold="${boldon}${esc}[37m"

reset="${esc}[0m"
 

# This is not necessary for git bash, as there is no root user from what I can tell, but it's nice to have laying about..
# I have not explored ways to run git bash as Administrator.  I don't see an obvious way to do it.
case $(id -u) in
  0)
    user_color=${red_bold}
  ;;
  *)
    user_color=${cyan_bold}
  ;;
esac


# The default is:
# \[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[35m\]$MSYSTEM \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ 
# TODO? - I could modify PROMPT_COMMAND to do fancy things with the prompt..
# There are issues with a very long prompt and having the cursor directly after it.  Wrapping is messed up.
PS1="\w$( __git_ps1 ) \$\n${user_color}>$reset "


# Set the title bar.
export  PROMPT_COMMAND='echo -ne  "\033]0;$PWD\007"'


# Turn off automatic Windows-Unix line-ending conversion (best to manage this yourself with a good text editor).
#   http://www.portablefreeware.com/forums/viewtopic.php?p=66583#p66583
\git  config  --global  core.autocrlf true



sourceallthat() {
  source  "$1"/lib.sh
  for i in "$1"/*.sh; do
    source  "$i"
  done
}
sourceallthat  "$shell_random/live/sh"
sourceallthat  "$shell_random/live/bash-windows"
sourceallthat  "$shell_random/live/bash and zsh"



# I so frequently check for disk space that I ought to do it automatically.
if [ "$PWD" == "/" ]; then
  \cd  ~
fi
\df  --human-readable
echo



\echo -n " * Testing internet connection... "
# example.com is supposed to be provided by the ISP.
\ping  -n  -q  -w 2  example.com  &> /dev/null
# ping not found || ping doesn't find a connection
if [[ $? -eq 127 || $? -eq 2 ]]; then
  \echo  "[FAIL]"
 else
  \echo  "[ok]"
fi
