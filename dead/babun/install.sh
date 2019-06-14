#!/usr/bin/env  sh


# Note that a script With no shebang must be run like `bash script.sh`



if [ ! -L /l ]; then
  \ln  --force  --no-target-directory  --symbolic  --verbose  /d/live/  /l
fi



if [ ! -L ~/.zshrc ]; then
  \mv  --verbose  ~/.zshrc  ~/.zshrc--ORIGINAL
  \ln  --symbolic  --verbose  /l/shell-random/git/live/zsh/dot_zsh  ~/.zsh
  \ln  --symbolic  --verbose  ~/.zsh/3-interactive.sh  ~/.zshrc

  {  #  Fix startup compinit errors
     #  A new installation of Cygwin will give:
     #   Ignore insecure directories and continue [ny]?
     #
     # https://stackoverflow.com/questions/13762280
     # http://www.wezm.net/technical/2008/09/zsh-cygwin-and-insecure-directories/
    \compaudit | \xargs \chmod  g-w
  }
fi



\chmod  0700  /home/user/.git-credential-cache
