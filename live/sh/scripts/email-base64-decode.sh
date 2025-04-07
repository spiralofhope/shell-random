#!/usr/bin/env  sh

# Decodes emails so they can be edited.


\xclip -o -selection clipboard |\
  \tr -d '\r\n' |\
  \base64 -d |\
  \xclip -selection clipboard ||\
echo "Failed: Invalid Base64 or empty clipboard."



\echo 'also change'
\echo 'Content-Transfer-Encoding: base64'
\echo 'to:'
\echo 'Content-Transfer-Encoding: 8bit'



# xclip -o -selection clipboard | tr -d '\r\n' | base64 -d | xclip -selection clipboard || echo "Failed: Invalid Base64 or empty clipboard."
