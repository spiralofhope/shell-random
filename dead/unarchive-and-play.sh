:<<NASTY_BUG
if the unc directory already exists, this can be very dangerous and delete the current directory!
NASTY_BUG

:<<REQUIREMENTS
- wc
- unc (my script) and any appropriate un-archiving software..
- mcd (my script)
- find
- audacious or your player of choice
REQUIREMENTS

# Parameter-checking
ARCHIVE="$1"

# Sanity-checking
# Should also check for this..
# Can I tell if unc was sourced properly?
source /home/user/bin/zsh/unc.sh
source /home/user/bin/zsh/delme.sh
# source /home/user/bin/zsh/mine.sh
mcd() { mkdir "$1" && cd "$1" ; }

# User-configurable
player() {
echo "$1"
  "nohup" audacious "$1" > /dev/null&
# TODO: Detect if audacious is already running.  If so, then just stick this item at the top of the queue and begin playing it.
#   "nohup" audacious --enqueue "$FILE" > /dev/null&
}

"unc" "$ARCHIVE"
# ARCHIVE="$1"
# EXTENSION="${ARCHIVE##*.}"
# BASENAME="${ARCHIVE%.*}"
# mcd "$BASENAME"
# rar x ../"$ARCHIVE"

# Check for an exit code?  I don't provide one yet..
# Count the number of files
COUNT=`"ls" -1|"wc" --lines`
# If there are 0-3 files..
if [ "$COUNT" -lt 3 ]; then

  # For all the files that we unpacked.
  ARCHIVE_FILES_ARRAY=( * )
#   ARCHIVE_FILES_ARRAY=( `find -maxdepth 1 -type f` )
  MODS_ARRAY=( amf AMF s3m S3M mod MOD far FAR mdl MDL xm XM )
  for FILE in "${ARCHIVE_FILES_ARRAY[@]}" ; do
    EXT="${FILE##*.}"
    for MOD in "${MODS_ARRAY[@]}"; do
      if [ "$EXT" = "$MOD" ]; then player "$FILE" ; fi
    done
  done

fi

# I need to do this so that audacious can launch and begin playing the file before I delete everything underneath it.
"sleep" 4
# Oh so dangerous...
# delme
"delme" -f


:<<ENDNOTES

~/.sfm should have:

# Creating an archive...
# This works on lower and uppercase extensions.
.amf-->rar a -df '%s'.rar '%s'
.s3m-->rar a -df '%s'.rar '%s'
.mod-->rar a -df '%s'.rar '%s'
.far-->rar a -df '%s'.rar '%s'
.mdl-->rar a -df '%s'.rar '%s'
.xm-->rar a -df '%s'.rar '%s'

# Unpacking and playing
.rar-->/home/user/bin/unarchive-and-play.sh '%s'
