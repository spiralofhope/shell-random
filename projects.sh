# Was working decently.  I re-did this to solve my odd multiple-geany-window issue.

PROJECTS="/home/user/live/projects"
# Doesn't fucking work when ~/live is a symlink which isn't pointing anywhere
# if [ ! -d $PROJECTS ]; then
\ls $PROJECTS/.
if [ $? != "0" ]; then
  \echo "ERROR:  \"$PROJECTS\" does not exist!"
  return 1
fi

# Where {} is the name of the directory.
NOTES='{}.txt'
# NOTES="project-notes.txt"
# The message put in the new project notes file, if one needs to be made.
MESSAGE="New project notes started `date`"

## If it isn't running, start it.
#ps alx|grep medit
#if [ $? -eq 1 ]; then
  #medit&
  ## Because calling medit so rapidly when it doesn't already exist will open many medit instances, I do this..
  #sleep 2
#fi

# Nope, I can't even do this.. because I have to sleep to allow the program to start up.
#"nohup" "medit" >> /dev/null & ; PID=$!
#EXIT="1"
#until [ $EXIT != "1" ]; do
#  sleep 0.1
#  "ps" -p $PID -o comm= ; EXIT=$?
#  echo $EXIT
#done
# sleep 3

#TODO - sanity-check $PROJECTS to make sure it's a directory, and that I can CD into it.
# Make sure the files are readible
cd "$PROJECTS"

# TODO - how can I get all of this launched in a nice and sorted manner?
find . -maxdepth 1 -type d \
  -exec sh -c "
    if [ ! -f '{}'/'$NOTES' ]; then
      \echo '$MESSAGE' > '{}'/'$NOTES'
    fi
  " \; \
  -exec sh -c "\geany '{}'/'$NOTES' &" \; \
  -exec sh -c "\ls '{}'" \; \
  -exec sh -c "\sleep 0.1" \;
}
# The sleep has been added to ensure that one single geany window has all the files opened as tabs within it.  It's been opening multiple windows which is horribly messy!
# .. but it doesn't work.

# Another method which seems pretty interesting but ended up being annoying because find was giving a leading "./"
# TODO: I ought to solve that.  It should be easy.  Then I can do so much more!
#\find . -maxdepth 1 -type d -print |
#while \read i ; do
  #\echo "$i"/"$i".txt
  #\echo ""
  #\sleep 0.1
#done

# This'll delete any stray project notes that get placed throughout my ~ and its subdirectories due to a misfire.
# find ~/ -maxdepth 1 -type f -name 'project-notes.txt' -exec rm -v {} \;
