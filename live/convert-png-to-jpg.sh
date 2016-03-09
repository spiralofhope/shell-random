#!/usr/bin/env  zsh

# TODO - the **/*.png should be the responsibility of the user at the commandline, not this script.  Mimic the other thing I did with that other script that one time (at band camp)

# WARNING - This will blindly destroy animated PNGs!
# TODO - detect and skip animated PNGs.

# The original which I used on the commandline:
#   for i in **/*.png; convert "$i" "$i".jpg ; jpegoptim **/*.png.jpg -p ; rename 's/\.png\.jpg/\.jpg/' **/*.jpg ; rm -f **/*.png



_die_on_failure(){
  if [ $? -ne 0 ]; then
    _exit=$?
    \echo "skipping!"
    exit $_exit
  fi
}



# TODO - use find for everything, all in one go.  My early attempts sucked..
# FIXME - errors should be checked for and delt with!
# I can't effectively do this.. if there are no .PNG (caps) files then it fails.. sigh.
#for i in **/*.png  **/*.PNG; do
for i in **/*.png; do
  \echo  "$i"

  \convert  "$i" "$i".jpg
  # It's ok if something fails to convert (usually because it's a broken image), just don't try to do anything else with it..
  if [ $? -ne 0 ]; then continue ; fi

  # I don't think `jpegoptim` is _ever_ useful for images processed by `convert` (imagemagick).  It seems to do things The Right Way.
  \jpegoptim  --quiet  "$i".jpg  --preserve
  _die_on_failure

  \rename  's/\.png\.jpg/\.jpg/i'  "$i".jpg
  _die_on_failure

  \rm  --force  "$i"
  _die_on_failure
done
