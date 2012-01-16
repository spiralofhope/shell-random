unc() {

VERSION="0.1.3, 2009-05-22"
: <<'COMMENTBLOCK'

----
Todo
----
Note:  Scan this file for other misc. 'TODO' items.

- Complete some documentation
- Consider other archivers
- Build a full list of archivers in here, and list the tested version numbers, testing date and author/website ?

-------
History
-------
0.1.3, 2009-05-22 -- I wasn't properly quoting variables, giving unexpected results with files with spaces in their name.
0.1.2, 2009-05-16 -- added .tgz support
0.1.1, 2009-03-29 -- Since most filename.tar.gz will create "filename" already, detect it and avoid the duplicate directory structure.
0.1.0, 2009-03-25 -- First successful beta, thanks to figuring "break" out.
COMMENTBLOCK

  # TODO: Put some of this crap in another script somewhere, then use 'source filename.sh'?  (test)

  reset_colour() {
    # darkgrey on black
    # TODO: What if there is a different foreground or background colour preference?
    # Learn the current colours, and restore them intelligently?
    printf "\x1b\x5b0;40;40m"
  }
  black()       { printf "\x1b\x5b0;30;40m$1\n";reset_colour ; }
  darkgray()    { printf "\x1b\x5b1;30;40m$1\n";reset_colour ; }
  blue()        { printf "\x1b\x5b0;34;40m$1\n";reset_colour ; }
  lightblue()   { printf "\x1b\x5b1;34;40m$1\n";reset_colour ; }
  green()       { printf "\x1b\x5b0;32;40m$1\n";reset_colour ; }
  lightgreen()  { printf "\x1b\x5b1;32;40m$1\n";reset_colour ; }
  cyan()        { printf "\x1b\x5b0;36;40m$1\n";reset_colour ; }
  lightcyan()   { printf "\x1b\x5b1;36;40m$1\n";reset_colour ; }
  red()         { printf "\x1b\x5b0;31;40m$1\n";reset_colour ; }
  lightred()    { printf "\x1b\x5b1;31;40m$1\n";reset_colour ; }
  purple()      { printf "\x1b\x5b0;35;40m$1\n";reset_colour ; }
  lightpurple() { printf "\x1b\x5b1;35;40m$1\n";reset_colour ; }
  brown()       { printf "\x1b\x5b0;33;40m$1\n";reset_colour ; }
  yellow()      { printf "\x1b\x5b1;33;40m$1\n";reset_colour ; }
  lightgrey()   { printf "\x1b\x5b0;37;40m$1\n";reset_colour ; }
  white()       { printf "\x1b\x5b1;37;40m$1\n";reset_colour ; }

  # And without the trailing carriage return:
  pblack()       { printf "\x1b\x5b0;30;40m$1";reset_colour ; }
  pdarkgray()    { printf "\x1b\x5b1;30;40m$1";reset_colour ; }
  pblue()        { printf "\x1b\x5b0;34;40m$1";reset_colour ; }
  plightblue()   { printf "\x1b\x5b1;34;40m$1";reset_colour ; }
  pgreen()       { printf "\x1b\x5b0;32;40m$1";reset_colour ; }
  plightgreen()  { printf "\x1b\x5b1;32;40m$1";reset_colour ; }
  pcyan()        { printf "\x1b\x5b0;36;40m$1";reset_colour ; }
  plightcyan()   { printf "\x1b\x5b1;36;40m$1";reset_colour ; }
  pred()         { printf "\x1b\x5b0;31;40m$1";reset_colour ; }
  plightred()    { printf "\x1b\x5b1;31;40m$1";reset_colour ; }
  ppurple()      { printf "\x1b\x5b0;35;40m$1";reset_colour ; }
  plightpurple() { printf "\x1b\x5b1;35;40m$1";reset_colour ; }
  pbrown()       { printf "\x1b\x5b0;33;40m$1";reset_colour ; }
  pyellow()      { printf "\x1b\x5b1;33;40m$1";reset_colour ; }
  plightgrey()   { printf "\x1b\x5b0;37;40m$1";reset_colour ; }
  pwhite()       { printf "\x1b\x5b1;37;40m$1";reset_colour ; }

  error() {
    pred ERROR:
    echo "  \""$FILE"\" $1"
    echo ""
    help
  }
  error_plain() {
    pred ERROR:
    echo "  $1"
    echo ""
    help
  }

  FILE="$1"
  EXTENSION="${FILE##*.}"
  BASENAME="${FILE%.*}"

  # Main loop
  until [ "sky" = "falling" ]; do

    help() {
      echo "Usage: `basename $0` filename.ext"
      echo ""

      # I could use a here document like so:
      cat <<'DOCUMENTATION'

      documentation testing
      TODO: \x1b\x5b1;33;40m colour doesn't work in a here document.  Maybe there's another way.

      Also see 'expect' for more complex interactive programs.

      this ending cannot have whitespace before it:
DOCUMENTATION
      break
    }

    # If no parameters were passed
    if [ ! -n "$1" ]; then help ; fi
#    if [ "$1" = "-v" | "--version" ]; then echo $VERSION ; help ; fi

    # If more than one parameter is passed
    # TODO if more than one switch, process each file?
    if [ -n "$2" ]; then error_plain "This script can only handle one archive file at a time!" ; fi
    if [ ! -e "$FILE" ]; then error "was not found." ; fi
    if [ ! -f "$FILE" ]; then error "is not a regular file." ; fi
    if [ ! -r "$FILE" ]; then error "is not readible." ; fi
    # QUIRK: The documentation says to just use "-s", but "! -s" seems to actually work the way I expect.
    #   TODO: Make a full test case and ask for help on this.
    if [ ! -s "$FILE" ]; then error "is size 0!" ; fi

    case "$EXTENSION" in
      tgz)
        # touch 1 ; tar -cf 1.tar 1 ; gzip 1.tar ; rm -f 1
        mcd "$BASENAME"
        tar -xvvzf ../"$FILE"
      ;;
      bz2) # check more:
        EXTENSION="${BASENAME##*.}"
        case "$EXTENSION" in
          tar) # .tar.bz2
            # touch 1 ; tar -cf 1.tar 1 ; bzip2 1.tar ; rm -f 1
            # strip out .tar
            BASENAME="${BASENAME%.*}"
            mcd "$BASENAME"
            tar -xvvjf ../"$FILE"
          ;;
          *) # .bz2
            # touch 1 ; bzip2 1
            mcd "$BASENAME"
            # --keep = Explicitly keep the original file.
            # Using bzcat because bzip2 will try to extract to the same directory as the archive.
            bzcat --keep --verbose ../"$FILE" > ./"$BASENAME"
        ;;
        esac
      ;;
      gz) # check more:
        EXTENSION="${BASENAME##*.}"
        case $EXTENSION in
          tar) # .tar.gz
            # touch 1 ; tar -cf 1.tar 1 ; gzip 1.tar ; rm -f 1
            # strip out .tar
            BASENAME="${BASENAME%.*}"
            mcd "$BASENAME"
            tar -xvvzf ../"$FILE"
          ;;
          *) # .gz
            # touch 1 ; gzip 1
            mcd "$BASENAME"
            # --to-stdout and the redirect are done so that the original file is kept.
            gzip --decompress --to-stdout ../"$FILE" > ./"$BASENAME"
        ;;
        esac
      ;;
      tar)
        # touch 1 ; tar -cf 1.tar 1 ; rm -f 1
        mcd "$BASENAME"
        tar -xvvf ../"$FILE"
      ;;
      zip)
        # touch 1 ; zip 1.zip 1 ; rm -f 1
        mcd "$BASENAME"
        unzip ../"$FILE"
      ;;
      rar)
        # touch 1 ; rar a 1.rar 1 ; rm -f 1
        mcd "$BASENAME"
        rar x ../"$FILE"
      ;;
      *)
        # TODO: If there's no period in the name, spit out another error.
        echo "I don't know how to handle a $EXTENSION"
      ;;
    esac

    # 0.1.1 - Since most filename.tar.gz will create "filename" already, detect it and avoid the duplicate directory structure.
    if [ -d ./"$BASENAME" ]; then
      for i in *; do
        if [ "$i" = "$BASENAME" ]; then
          :
        elif [ ! "$i" = "$BASENAME" ]; then
          FILEEXISTS="yes"
        else
          echo "Eek!"
        fi
      done
      if [ "$FILEEXISTS" = "yes" ]; then
        :
      elif [ ! "$FILEEXISTS" = "yes" ]; then
        # TODO: Remember the state of shopt and restore it after this script.
        # bash:
        # shopt -s dotglob
        # zsh:
        setopt dotglob
        mv "$BASENAME"/* ./
        rmdir "$BASENAME"
      else
        echo Eek!
      fi
    fi

    # End of the breakable main body.  And since I only want to iterate once, break!
    break
  done
}
