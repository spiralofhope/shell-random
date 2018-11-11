#!/usr/bin/env  sh



alias  cp='\cp  --interactive'
alias  mv='\mv  --interactive'
alias  rm='\rm  --interactive'
alias  md='\mkdir'
alias  du='\du  --human-readable'
alias  cls='\clear'
alias  more='less  --quit-at-eof  --quit-if-one-screen'

# This won't work on cygwin, and I'm not even sure what it was for..
#alias  cd='\cd  --no-dereference'
#alias  ..='  \cd  --no-dereference  ..'
#alias  cd..='\cd  --no-dereference  ..'
alias  ..='  \cd  ..'
alias  cd..='\cd  ..'

alias  less='\less  --RAW-CONTROL-CHARS'
#alias  less='\less  --force  --RAW-CONTROL-CHARS  --quit-if-one-screen  $@'
alias  nano='\nano  --mouse'

alias  df='_df_sorted 5'    # sorted by mountpoint
alias  df='_df_sorted 1'    # sorted by filesystem

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
alias  reboot="    /bin/su  -c  '/sbin/shutdown  -r  -t now  now  rebooting'"
alias  poweroff='  \sudo  /sbin/poweroff'

alias current=' \cd  /l/OS/current/'
alias previous='\cd  /l/OS/previous/'
