#!/usr/bin/env  sh



# A helper to decrypt a PGP block copied into the clipboard.

# I don't know if the  ;\  should just be a  \  or not, another version of this file was just  \

nohup \
\xterm  -fn 9x15  -bg black  -fg gray  -sl 10000  -geometry 113x46+0+0  -title 'decrypting'  -e \
$SHELL -c "
\xclip  -o  -sel  clip | \gpg  -d | \kwrite  --stdin ;\
" >> /dev/null&
