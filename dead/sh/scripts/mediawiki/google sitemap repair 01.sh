# 1.12.0 - The newer versions of MediaWiki don't seem to work with the default mediawiki sitemap or with this scripting!


# This was tested on the earlier PHP4 mediawiki versions

echo generating the sitemap...
cd /var/www/vhosts/example.com/httpdocs/maintenance/
php generateSitemap.php

echo prepping the files...
mv -f *.gz ../
mv -f *.xml ../
cd ..
gzip -d *.xml.gz

echo repairing the index file...
sed 's/<loc>/<loc>http:\/\/example.com\//g' sitemap-index-mediawiki.xml > sitemap-index-mediawiki.xml.sed
mv sitemap-index-mediawiki.xml.sed sitemap-index-mediawiki.xml

echo repairing the files...
for i in $( ls *.xml ); do
  sed 's/example.com/example.com/g' $i > $i.sed
done
ls -d *.sed | sed 's/\(.*\).sed$/mv "&" "\1"/' | sh

echo gzip it all back up...
gzip *.xml
gzip -d sitemap-index-mediawiki.xml.gz

echo done.
