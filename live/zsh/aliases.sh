# --
# --  Zshisms
# --

# MIME is possible, but I can't figure it out.
# autoload -U zsh-mime-setup
# zsh-mime-setup

# --  Suffix aliases
alias  -s txt=medit
alias  -s pdf=xpdf

# --  Aliases for builtins
alias  cp='nocorrect  \cp  --interactive'
alias  mv='nocorrect  \mv  --interactive'
alias  rm='nocorrect  \rm  --interactive'
alias  mkdir='nocorrect  \mkdir'



# --
# -- Linux console Applications
# --

# TODO - Works for Ubuntu.  Make this universal.
#alias  su="\sudo  $SHELL"
# Universal?
alias  su="\sudo  $( \basename  $( \readlink  /proc/$$/exe ) )"

# Go fuck yourself, drive.
alias  eject='\eject  -i 0 ; \eject'
# bash-windows does not support --color
alias  grep='\grep --color'

# TODO - What was I trying to achieve with this?
# TODO - Improve
#alias  killjobs='\kill  -9  $( \jobs -p )'

# TODO? - What does this do?
# alias  screen='TERM=screen screen'  # http://ubuntuforums.org/showthread.php?t=90910

alias pm-suspend='\sudo  /usr/sbin/pm-suspend'
alias reboot='    \sudo  /usr/sbin/reboot'
alias poweroff='  \sudo  /usr/sbin/poweroff'
