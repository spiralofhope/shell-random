#!/usr/bin/env  zsh



#:<<'}'  #  Taken from  `zsh-replace-realpath.sh`
_zsh_realpath() {
  local file=$1 var_name=$2
  typeset -g "$var_name=${file:A}"
}



_zsh_realpath '/path/to/symlink' variable_name
