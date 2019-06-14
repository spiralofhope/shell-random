#!/usr/bin/env  sh

# sudo comes with it, and it saves the password so it'll only prompt once..
# and /bin/su -c doesn't work as-expected.. presumably because there's no root account.

\sudo  \apt-get  update
\sudo  \apt-get  upgrade
\sudo  \apt-get  dist-upgrade

\sudo  \apt-get install  -y  \
  ` # Commandline ` \
  fdupes \
  git \
  jpegoptim \
  man \
  mercurial \
  p7zip-full \
  subversion \
  zsh \
  ` # zsh-doc ` \
  ` # GUI ` \
  geany \
  leafpad \
` # `

\chsh  user  --shell /usr/bin/zsh
\ln  -s /mnt/d/live  /l
