#!/usr/bin/env  zsh
# Note that `zstyle` is a zshism



# completion for *lots* of commands - man, ssh, etc
zmodload  -i  zsh/complist
## Tab completion.
zstyle      ':completion:*'                 list-colors  ${(s.:.)LS_COLORS}  matcher-list  'm:{a-zA-Z}={A-Za-z}'
zstyle      ':completion:*'                 matcher-list  'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'  'r:|[._-]=* r:|=*'  'l:|=* r:|=*'
#zstyle      ':completion:*'                 _approximate  completer  _complete  _ignored
zstyle      ':completion::complete:*'       use-cache  1

### If you want zsh's completion to pick up new commands in $path automatically
### comment out the next line and un-comment the following 5 lines
zstyle      ':completion:::::'              completer  _complete  _approximate
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return  1  # Because we didn't really complete anything
}
zstyle      ':completion:::::'              completer  _force_rehash  _complete  _approximate
zstyle  -e  ':completion:*:approximate:*'   max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle      ':completion:*:descriptions'    format "- %d -"
zstyle      ':completion:*:corrections'     format "- %d - (errors %e})"
zstyle      ':completion:*:default'         list-prompt '%S%M matches%s'
zstyle      ':completion:*'                 group-name ''
zstyle      ':completion:*:manuals'         separate-sections true
zstyle      ':completion:*:manuals.(^1*)'   insert-sections true
zstyle      ':completion:*'                 menu select
zstyle      ':completion:*'                 verbose yes
