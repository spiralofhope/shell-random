# -----------------------------
until [ "sky" = "falling" ]; do
# -----------------------------

:<<NOTES
wget --force-directories --continue --referrer="$referrer" $file
NOTES

:<<TODO
next up: assume this:
Primary HTML
-> Secondary HTML has a large picture which is linked to another page
-> Large-sized image HTML which is either linked to another page or linked to a large-sized image.
TODO

BASE="http://www.example.com/dir/"
WORKING="/l/Downloads/leech/"

# This seems to be a simple way to snag all of the sub-files.  However, it's imperfect, since sometimes the gallery will be located elsewhere.  In that case, I would have to resurrect and finish my partial alternate code, below.
cd "$WORKING"
# wget --continue --no-parent --recursive --no-directories --level=1 --retry-connrefused $BASE
rm -f "index.html"

:<<ALTERNATE
# download a link.  -o it into a known-named HTML file.
#rm -f index.html
#rm -f index.html.*
rm -f href*.html
#wget "$BASE" --verbose -O index.html

# parse it and build a list of all HREF links.
grep -io -r "<a .*href.*</a>" ./index.html > ./href.html

#  for each link, review and keep links which have an img tag
grep -io -r "<img .*src.*>" ./href.html > ./href2.html

# parse it and build a list of all HREF links.
sed 's/>/>\n/g' < ./href2.html > ./href3.html
grep -io -r "<a .*href.*" ./href3.html > ./href4.html
# pull out all of the links
# FIXME: This can't handle <a href = with a space before or after the =
sed 's/<a href="//' < href4.html > href5.html
sed 's/">//' < href5.html > href6.html

cat ./href6.html

#  for each remaining link, review and download that HTML and -o into a known-named HTML file.
ALTERNATE


#  for each HTML, parse it and build a list of all images
# TODO: skip directories, somehow.  Sigh.
\cp ../backup/* .
for i in *; do
  #  for each link, review and keep links which have an img tag
  \cp "$i" "/tmp/$i"
  grep -io -r "<img .*src.*>" < "/tmp/$i" > $i
  \cp "$i" "/tmp/$i"
  sed '/>/ s/>/\r\n/g' "/tmp/$i" > $i


  \cp "$i" "/tmp/$i"
  grep -io -r ".*\.jpg.*" < "/tmp/$i" > $i
  grep -io -r ".*\.png.*" < "/tmp/$i" >> $i
  \cp "$i" "/tmp/$i"
  sed 's/"//' < "/tmp/$i" > $i
  rm -f "/tmp/$i"
  cat $i
done



#  determine the size of each image.  Maybe I can do that by looking at the code, but I should just download each image link then determine its size.
#  discard images which are too small
#  if any images remain, keep the largest


#--------------------------------------------------------------------
break
done
#--------------------------------------------------------------------
: <<HERE_DOCUMENT

This is the content of another leech.sh found elsewhere.  Here for reference.
TODO:  Absorb this into the existing downloader.



:<< TODO
check out 'dog' .. if I could find it.  =/
    $ dog --images http://www.dvdownload.nl
    http://www.dvddownload.nl/site/3821/front/w150/long_time_since.jpg
    http://www.dvddownload.nl/site/3822/front/w150/the_confidence_man.jpg
    http://www.dvddownload.nl/site/3823/front/w150/body_puzzle.jpg
    http://www.dvddownload.nl/site/3824/front/w150/betty.jpg
    http://www.dvddownload.nl/site/3826/front/w150/perfect_lover.jpg
    http://www.dvdownload.nl/'images/spacer.gif'
    http://www.dvdownload.nl/images/spacer.gif
    http://www.dvdownload.nl/images/top.gif



- Make another script which will normalize directories by appending zeroes.  I need to be able to say dirst= or files="001..010" in some nice way.
  - This is easy to do with something like:  rename 's//0/' ??
- Extend this to add a description to each file, with the download location.
  - Not very important, since I create a directory tree.
TODO

dir_before="http://example.com/dir/"
dirs="1..2"
dir_after="/"

file_before=""
files="1..1"
file_after=".wmv"


ROOT="/l/Downloads/leeched/"
cd $ROOT

for i in {$dirs}; do
  for j in {$files}; do
    referrer="$dir_before""$i""$dir_after"
    file="$dir_before""$i""$dir_after""$file_before""$j""$file_after"
    echo $file
    # --force-directories will build a nice directory tree for me.  Sweet.
    wget --no-verbose --force-directories --continue --referrer="$referrer" $file
  done
done
