#!/usr/bin/env  sh



user=example
pass=example



\lftp \
  -u $user,$pass \
  -e "\
    set ssl:verify-certificate false && \
    mirror --continue --parallel=3 --verbose . ./LEECH/ \
  "\
  example.com
