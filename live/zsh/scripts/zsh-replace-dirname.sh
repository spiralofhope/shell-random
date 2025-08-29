#!/usr/bin/env  zsh



#:<<'}'   #  There is also  `replace-dirname.sh`
_zsh_dirname() {
  local dir=${1:-.}
  local var_name=$2
  dir=${dir:h}
  [[ -z $dir ]] && dir=/
  typeset -g "$var_name=$dir"
}



_zsh_dirname "$variable" same_or_different_variable
