#!/bin/sh
# Create a series of symlinks for $HOME
# See README.markdown



:<<'}'   #  Notes
{
# Note that any open applications will probably fuck with this script.  Known problem-software:
#   - Chromium (date not recorded, version not recorded)

# FIXME - zsh_histfile cannot be converted into a symlink while in a zsh shell!
#         workaround:  \sh, then \ln, then \kill zsh (which also kills the terminal)
}



#:<<'}'   #  Must not be run as root
{
  if [ "$USER" = 'root' ]; then
    \echo  'do not run as root'
    \exit  1
  fi
}



PWD="$( \realpath "$PWD" )"
date="$( \date +%Y-%m-%d--%H-%M-%S )"



#:<<'}'   #  Setup
_setup() {
  \echo  ''
  # Just in case.
  \mkdir  --parents  --verbose  ~/.config
  \mkdir  --parents  --verbose  ~/.local/share
  \mkdir  --parents  --verbose  ~/.local/share/data
}



#:<<'}'   #  Go
_go() {
  source="$( \realpath "$1" )"  ;  if [ $? -ne 0 ]; then return; fi
  target="$( \realpath "$2" )"  ;  if [ $? -ne 0 ]; then return; fi
  \echo  ''
  \echo  ''
  \echo  " * Processing source:  $source"
  \echo  " *            target:  $target"
  \echo  ''
  \cd  "$source"                ;  if [ $? -ne 0 ]; then return; fi
  for i in  *   \
            .*  ; do
    # It's not ideal to skip directories in this manner, but making assumptions makes the code cleaner.
    #   So this would ignore things like  ~/.local/data  if it existed.
    if [ "$i" = '.'       ] ||
       [ "$i" = '..'      ] ||
       [ "$i" = '.config' ] ||
       [ "$i" = '.local'  ] ||
       [ "$i" = 'data'  ] ||
       [ "$i" = "$( \basename "$0" )" ]; then
      continue
    fi
    # Back up existing items.
    if [   -e "$target/$i" ] && \
       [ ! -L "$target/$i" ]; then
      \mv  --verbose  "$target/$i"  "$target/${i}--${date}"
    fi
    \ln  --force  --no-target-directory  --symbolic  --verbose  "$PWD"/"$i"          "$target/$i"
  done
    \ln  --force  --no-target-directory  --symbolic  --verbose  "$PWD"/              "$target/00--dotfiles"
  \cd  -
}



#:<<'}'   #  Teardown
_teardown() {
  \echo  ''
}



_setup
_go  .  ~/
_go  .local/share/       ~/.local/share/
_go  .local/share/data/  ~/.local/share/data/
_go  .config/            ~/.config/
_teardown



\echo ' .. done. '
