# .zshrun

# replaced readrun
# 2018-04-07 - untested


HISTFILE=~/.zsh/histfile-zshrun
HISTSIZE=100
SAVEHIST=100
PS1=""
# terminal title
chpwd() { print "" }
setopt appendhistory nomatch notify
unsetopt beep autocd
