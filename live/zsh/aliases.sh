#!/usr/bin/env  zsh



# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup

alias  apt='nocorrect      \apt'
alias  cp='nocorrect       \cp  --interactive  --preserve=all'
# On WSL2, I am using a path for git.exe being
# /mnt/c/Program Files/Git/cmd/git.exe
# And so I don't want to nocorrect it
#alias  git='nocorrect      \git'
alias  killall='nocorrect  \killall'
alias  ls='nocorrect       \ls  -1  --all  --classify  --color=always  --group-directories-first  --show-control-chars'
alias  man='nocorrect      \man'
alias  mv='nocorrect       \mv  --interactive'
alias  mkdir='nocorrect    \mkdir'
alias  ping='nocorrect     \ping'
alias  rm='nocorrect       \rm  --interactive  --one-file-system'

# FIXME - These cannot be done in this manner.  I could summon them directly with the .sh but they'd have to be in the path.
#alias  geany='nocorrect     geany'
#alias  mcd='nocorrect       mcd'


# --  Suffixes
alias  -s pdf=xpdf
alias  -s txt=geany
