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

alias  df='_df_sorted 5'    # sorted by mountpoint
alias  df='_df_sorted 1'    # sorted by filesystem
