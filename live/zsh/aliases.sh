#!/usr/bin/env  zsh



# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup

# --  Suffix aliases
alias  -s txt=geany
alias  -s pdf=xpdf

# --  Aliases for builtins
alias  ls='\ls  -1  --all  --classify  --color=always  --group-directories-first  --show-control-chars'
alias  cp='nocorrect  \cp  --interactive  --preserve=all'
alias  mv='nocorrect  \mv  --interactive'
alias  rm='nocorrect  \rm  --interactive  --one-file-system'
alias  mkdir='nocorrect  \mkdir'
alias  man='nocorrect  \man'
alias  ping='nocorrect  \ping'



# --
# -- Linux console Applications
# --

# 2016-03-26 - Lubuntu (version not recorded)
# 2016-03-28 - Slackware 14.1
#alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"
#alias  sul='\sudo  \su  --login'

# Go fuck yourself, drive.
alias  eject='\eject  -i 0 ; \eject'
# bash-windows does not support --color
alias  grep='\grep --color'

# TODO - What was I trying to achieve with this?
# TODO - Improve
#alias  killjobs='\kill  -9  $( \jobs -p )'

# TODO? - What does this do?
# alias  screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910

alias  pm-suspend='\sudo  /usr/sbin/pm-suspend'
alias  reboot='    \sudo  /sbin/reboot'
alias  poweroff='  \sudo  /sbin/poweroff'

alias current=' \cd  /l/OS/current/'
alias previous='\cd  /l/OS/previous/'

alias git='nocorrect  \git'
