#!/usr/bin/env  zsh



# TODO: Change directory and don't bother requiring double-quotes in the string..
# I just use some trickery with control-x



:<<'}'
cd() {
  # This isn't working..
  # zshism
  # shellcheck disable=2039
  dir=${*:gs/~/\\\\~/}
  builtin cd "$dir" || return
}

#:<<'}'
ccd() {
  # zshism
  # shellcheck disable=2124
  a="$@"
  \echo  "$a"
  # b=${a:gs/ /\\\\ /}
  # probably a zshism
  # shellcheck disable=2154
  b=${(q)a}
  \echo  "$b"
  \cd  "$b" || return
}
