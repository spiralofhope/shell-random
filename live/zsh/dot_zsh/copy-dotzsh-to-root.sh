#!/usr/bin/env  sh



# As root:
if ! [ "$USER" = 'root' ]; then
  # TODO/FIXME - check if sudo exists
  \echo  'enter root password'
  /bin/su  --command  "$0"
else



\rm  --force  --recursive \
  /root/.zsh \
  /root/.zshenv \
  /root/.zshrc
\mkdir  /root/.zsh
\cp  --archive  --force  /home/user/.zsh/*  /root/.zsh
\chown  --recursive  root:root  /root/.zsh
/root/.zsh/rebuild-zsh-symlinks.sh



fi   # The above is run as root
