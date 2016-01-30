# These work on zsh and bash-windows

# bash-windows tested 2016-01-29 on Windows 10, updated recently
#   GNU bash, version 3.1.20(4)-release (i686-pc-msys)


alias  ls='\ls  -1  --classify  --color=auto  --group-directories-first  --show-control-chars'
alias  cp='\cp  --interactive'
alias  mv='\mv  --interactive'
alias  rm='\rm  --interactive'
alias  md='\mkdir'
# -P  Do not follow symbolic links
alias  cd='\cd  -P'
alias  ..='  \cd  -P  ..'
alias  cd..='\cd  -P  ..'
alias  du='\du  --human-readable'
alias  cls='\clear'
alias  more='less  --quit-at-eof  --quit-if-one-screen'
alias  less='\less  --RAW-CONTROL-CHARS'

# Had  --raw-control-chars  in the past, and this version was thought to be tidier.  I don't notice any issues.
alias  less='\less  --RAW-CONTROL-CHARS'
#alias  less='\less  --force  --RAW-CONTROL-CHARS  --quit-if-one-screen  $@'
# --follow-name would allow the file to be edited and less will automatically display changes.
LESS=' --force  --ignore-case  --long-prompt  --no-init  --silent  --status-column  --tilde  --window=-2'
export LESS
