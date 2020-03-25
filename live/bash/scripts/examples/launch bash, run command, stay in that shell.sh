#!/usr/bin/env  bash
# - Launch bash
# - Run commands
# - Stay in that bash shell

# https://stackoverflow.com/a/7193037



/usr/bin/env  bash  --rcfile  <( \
  \echo  \
  '
    .  $HOME/.bashrc    ;\
    \ls  --color=never  ;\
    \ls  --color=auto   ;\
'\
)
