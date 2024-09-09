#!/usr/bin/env  sh
# Prepare the various symlinks for a new zsh installation to use my dotfiles.



# TODO - move it out of the way if needed

\ln  --symbolic  ~/l/shell-random/live/zsh/dot_zsh/  ~/.zsh
# Note that ~/.zshenv is not read when zsh is started with -f
# It is /etc/zshenv which is always read, even if zsh is started with -f
\ln  --symbolic  ~/.zsh/1-every.sh  ~/.zshenv
\ln  --symbolic  ~/.zsh/2-login.sh  ~/.zprofile
\ln  --symbolic  ~/.zsh/3-interactive.sh  ~/.zshrc
\ln  --symbolic  ~/.zsh/4-login.sh  ~/.zlogin
\ln  --symbolic  ~/.zsh/shutdown.sh  ~/.zlogout
