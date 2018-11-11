#!/usr/bin/env  zsh



# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup

# --  Suffix aliases
alias  -s txt=geany
alias  -s pdf=xpdf

# --  Aliases for builtins
alias  ls='nocorrect  \ls  -1  --all  --classify  --color=always  --group-directories-first  --show-control-chars'
alias  cp='nocorrect  \cp  --interactive  --preserve=all'
alias  mv='nocorrect  \mv  --interactive'
alias  rm='nocorrect  \rm  --interactive  --one-file-system'
alias  mkdir='nocorrect  \mkdir'
alias  man='nocorrect  \man'
alias  ping='nocorrect  \ping'



# --
# -- Linux console Applications
# --

alias git='nocorrect  \git'
