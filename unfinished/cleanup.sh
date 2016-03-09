echo "## Thumbnails"
rm -rf /home/work/.thumbnails

echo "## .thunderbird"
# So that I don't forget to close it.  If I forget, then it'll linger
# around checking email while I'm at the other location!
killall -q thinderbird-bin
find /home/work/.thunderbird -name '*' -type d -exec chmod 770 {} \;
find /home/work/.thunderbird -name '*' -type f -exec chmod 660 {} \;

echo "## .mozilla/firefox"
rm -rf /home/work/.mozilla/firefox/work/Cache/*

echo "## konqueror"
echo "   todo - cache cleanup"

echo "## .Skype"
chown work:work /home/work/.Skype -R
find /home/work/.Skype -name '*' -type d -exec chmod 770 {} \;
find /home/work/.Skype -name '*' -type f -exec chmod 660 {} \;

echo "## done"
