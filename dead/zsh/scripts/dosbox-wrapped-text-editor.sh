#!/usr/bin/env  zsh
# (untested)



# Last edited 2011-08-09 09:59:23



:<< TODO
Long filenames are truncated automatically.  Create a workaround:
- count the length of the filename
- create a temporary working filename of legal length
- upon exiting back to Linux, overwrite the original file

Long paths explode in a messy way.  Create a workaround:
- copy the filename to a temporary location
- upon exiting back to Linux, overwrite the original file

Maybe I just ought to do both of those things by default.

Possibly explore DOS long filename drivers.
TODO



edit() {
  # A Linux path to your dos stuff.
  dosdir="/home/user/_public/live/dos/dos/"
  # This is a path from the C: DOSBox mountpoint.
  editor="C:\dos\edit.com"
#   editor="C:\8088\utils\ted3.com"
#   editor="C:\8088\utils\works\works.exe"
  # create the file if it doesn't already exist?
#   create=1

  file=$1

  # This routine is good for editors which complain about a file not existing
  #  first, like Microsoft Works 3.0
  if [ $create -eq 1 ]; then
    # If it doesn't exist
    if [ ! -f $file ]; then
      # Create it
      echo : >> $file
    fi
  fi

  # get the full path of $1
  file=`readlink -f $file`
  # now convert /path/to/file to the DOS-style \path\to\file
  file=`echo $file|sed 's/\//\\\/g'`
  echo "D:$file"

  # DOSBox doesn't like it if you mount the root.
  # If some future version complains, then as root do something like:
  #   mount -o bind / /home/user/mounted-root
  dosbox \
  -c "mount d /" \
  -c "mount c $dosdir" \
  -c "c:" \
  -c "$editor D:$file" \
  -c "exit"
}
