#!/usr/bin/env  bash



:<<'}'   #  Ancient
{
s=something
echo ${s:0:1}
# =>
# s
}


:<<'}'   #  Ancient
{
FILE=whatever.ext
BASENAME=${FILE%.*}

# 1.tar.bz2 => tar.bz2
# 1.test.test.tar.bz2 => test.test.tar.bz2 (bad idea!)
EXT=${FILE#*.}
# 1.tar.bz2 => bz2 (better!)
EXT=${FILE##*.}

untested:

# dirname
dirname=`dirname "$file"`
# everything before last '/'
basename=${file%/*}
}
