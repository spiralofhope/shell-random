# -ls  start as a login shell, so it inherets aliases and such
export PS1=$PS1"\[\e]0;\H:\w\a\]" 
export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]' 
aterm -ls -fn 9x15 -bg black -fg gray -sl 10000 -geometry 113x46+0+0 $@
