mp3dir="/home/user/media/music/sorted/ /home/user/media/music/unsorted-tested"
builtdir=/home/user/media/_built
faves=$builtdir/favourites


echo "* Building Favourites/"

if [ -e $builtdir ] ; then
  echo "  .. $builtdir exists"
else
  echo "  ERROR: Misconfigured faves $builtdir:  " $builtdir
  echo "exiting."
  exit
fi

#if [ -e $mp3dir/ ] ; then
#  echo "  .. $mp3dir exists"
#else
#  echo "  ERROR: Misconfigured faves $mp3dir:  " $mp3dir
#fi

if [ -e $faves/ ] ; then
  echo "  .. deleting old favourites directory:  " $faves
  rm -rf $faves/
else
  echo "  .. favourites directory doesn't exist yet:  " $faves
fi

echo "  .. making new favourites directory:  " $faves
mkdir $faves/

echo "* Building Favourites list:  " $faves
echo ""
find $mp3dir/ -name '*~.mp3' -exec ln --symbolic {} --target-directory=$faves/ \;
echo ""
echo "done."

