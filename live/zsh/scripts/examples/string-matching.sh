#!/usr/bin/env  zsh



#:<<'}'   #  Find all characters after.
{
  # After the first occurrance
  string="test test"
  pattern="s"

  # zshism
  # shellcheck disable=2086
  \echo  ${string#*${pattern}}

  # ----

  # After the last occurrance
  string="test test"
  pattern="s"

  # zshism
  # shellcheck disable=2086
  \echo  ${string##*${pattern}}
}
