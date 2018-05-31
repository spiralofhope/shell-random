# TODO: Change directory and don't bother requiring double-quotes in the string..
# I just use some trickery with control-x



:<<'}'
cd() {
  # This isn't working..
  dir=${*:gs/~/\\\\~/}
  builtin cd "$dir"
}
:<<'}'
ccd() {
  a="$@"
  \echo $a
  # b=${a:gs/ /\\\\ /}
  b=${(q)a}
  \echo $b
  \cd $b
}
