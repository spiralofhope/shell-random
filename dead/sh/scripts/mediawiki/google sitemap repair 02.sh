#!/bin/sh



# Tested with 1.12.0 and 1.13.0.

# I have NO IDEA why the provided sitemap generating php script hasn't worked in years, if ever.  It really needs some love.

# Inspired by:
#   https://web.archive.org/web/20091217220825/http://wiki.laptop.org/go/SEO_for_the_OLPC_wiki/sitemapgen
# I further-modified it so that it's a little more newbie-serviceable.

# UPDATE! "Google webmaster tools" reports that the xml file is an invalid format.  Presumably I made a mistake somewhere!
#   https://www.google.com/webmasters/tools/dashboard?hl=en



#################
# Configure me! #
#################

# What's the URL to your website?  Don't forget www. if you use that.
WEBSITE=example.com

# The "username_mediawiki" is the name of my wiki.
# Update it to match yours.
FILES=sitemap-username_mediawiki-NS_*.xml

# Where should search engines go to see your sitemap file?
SITEMAP_URL=http://example.com/sitemap.xml

# I place this script in a directory other than my httpdocs.
cd ../httpdocs



##############
# The Script #
##############

echo Sitemap script ...
cd maintenance/
php generateSitemap.php
echo Sitemap script ... done

echo Moving files, un'gz'ing ...
mv -f *.gz ../
cd ..
gzip -df *.xml.gz
echo Moving files, un'gz'ing ... done

echo Archiving old sitemap...
mv sitemap.xml sitemap.xml.$(date "+%Y%m%d%H")
echo Archiving old sitemap... done

echo Cating all of the name spaces ...
cat $FILES > sitemap.xml
echo Cating all of the name spaces ... done

echo Replacing "localhost" with $WEBSITE ...
sed -i 's,localhost,$WEBSITE,g' sitemap.xml
echo Replacing "localhost" with $WEBSITE ... done

echo Cleaning that up ...
sed -i "/?xml version/d" sitemap.xml
sed -i "/urlset/d" sitemap.xml
echo Cleaning that up ... done

echo Adding the XML headers back...
echo "" >> sitemap.xml
sed -i '1i\
<?xml version="1.0" encoding="UTF-8"?>\
' sitemap.xml
echo Adding the XML headers back... done

echo Cleaning up the catd files ...
rm $FILES
echo Cleaning up the catd files ... done

echo Pinging the sitemap update to the search engines ..
echo "  google.com"
wget -q -O /dev/null http://www.google.com/webmasters/tools/ping?sitemap=$SITEMAP_URL
echo "  yahoo.com"
wget -q -O /dev/null http://search.yahooapis.com/SiteExplorerService/V1/ping?sitemap=$SITEMAP_URL
echo "  ask.com"
wget -q -O /dev/null http://submissions.ask.com/ping?sitemap=$SITEMAP_URL
echo "  moreover.com"
wget -q -O /dev/null http://api.moreover.com/ping?u=$SITEMAP_URL
echo "  live.com"
wget -q -O /dev/null http://webmaster.live.com/ping.aspx?siteMap=$SITEMAP_URL
echo .. done
echo ""
echo All done
echo ""
