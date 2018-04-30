#!/usr/bin/env  bash


# 2012-05-15 on Lubuntu 12.04, updated 2012-05-14
# If that's not what you have, this probably won't work for you.
# Even if that's what you have, this may still not work for you.

:<<NOTES
err:d3d_caps:WineD3D_CreateFakeGLContext Can't find a suitable iPixelFormat.
err:d3d:InitAdapters Failed to get a gl context for default adapter
Direct3D9 is not available without OpenGL.

`winetricks d3dx9` failed.

trying with the unpatched wine 1.5.3 running ./foo.exe directly.

err:ntdll:RtlpWaitForCriticalSection section 0xa500ac "?" wait timed out in thread 0038, blocked by 0042, retrying (60 sec)

deleted ~/.wine and tried again

NOTES


# USE AT YOUR OWN RISK
# Don't run strange scripts without knowing what you're doing.
# This works for me.  I do not provide support.

# References:
# http://wiki.winehq.org/Patching
# http://appdb.winehq.org/objectManager.php?sClass=version&iId=25953


\echo " * Installing dependencies 1/2"
\sudo \apt-get build-dep wine1.4

\echo " * Installing dependencies 2/2"
# I needed these, and my setup was mostly-complete so I may have inadvertently installed other dependencies.
\echo y | \sudo \apt-get install \
  flex \
  bison \
  libfreetype6-dev \
  ` # `

# FIXME:  This assumes that winetricks is installed.
\echo " * Installing vcrun2008"
\winetricks vcrun2008

\echo " * Downloading patches.."
for i in `seq 86102 86105`; do
  \wget -c http://source.winehq.org/patches/data/$i -O $i.patch
done

\echo " * Downloading the wine source code.."
\echo "   This will take some time, be patient."
\git clone http://source.winehq.org/git/wine.git wine-git

\cd wine-git

\echo " * Applying patches.."
for i in ../*.patch; do
  \patch -p1 < "$i"
done

\echo " * Running post-patch script.."
# I don't actually know what this does.  =)
./tools/make_requests

\echo " * Compiling wine.."
\echo "   Zomg this will take a long time."
./configure && \
  \make depend && \
  \make && \
  \sudo \make install

\echo " * Finished installing $(/usr/local/bin/wine --version)"

\echo "   You can launch wine with:"
\echo "/usr/local/bin/wine"

\echo "   You probably want to do something like:"
\echo "/usr/local/bin/wine Diablo-III-Setup-enUS.exe"



