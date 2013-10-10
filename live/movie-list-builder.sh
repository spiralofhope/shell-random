#/bin/bash

:<<NOTES
- given a directory, and a text file
- get information from the directory and put it in the text file.

Things to get:
- Title  --  e.g. The 13th Warrior
- Year  --  e.g. 1999
- Spoken Language(s)  --  e.g. .ger for German  --  idea: make a mouseover link to give the full language name
- Movie notes  --  Whatever random thoughts I've had.  Put them in a text file which can be read in and placed with this movie, hidden in a spoiler tag.
- Wikipedia link  --  e.g. The 13th Warrior becomes https://en.wikipedia.org/wiki/The_13th_Warrior  --  if no link given, use the title (and note that this was a guess?).
- IMDB link  --  e.g. tt0120657 becomes http://www.imdb.com/title/tt0120657/  --  if no link given, reference an IMDB search (and note this fact)

I think it's best to have this information available within a subdirectory, as a set of files.  Put the info in the filenames themselves.

usage:

for i in *; do  movie-list-builder.sh $i /tmp/filename.html  ; done

TODO
- make a generic link concept
- how do I process series' ?

NOTES



_setup() {
  _tempdir=$( \mktemp  --directory  -p /tmp  --suffix=--movie-list-builder )
  \echo  $_tempdir
  \cd    $_tempdir

  # TODO - parameter sanity-checking.
  # TODO - this will become $1
  # TODO - get the full path, just to be safe?
  _directory="$_tempdir/The 13th Warrior (1999, .eng)"
  \mkdir  $_directory
  # TODO - this will become $2
  _textfile=$_tempdir/textfile.txt
  \touch  $_textfile
  \echo  __begin__  >>  $_textfile
  _output=""
  # If the file is new, then create the necessary HTML header.
  # Appent an HTML footer -- if one does not already exist.
}



_process_directory_name() {
  # Get the title, e.g.  The 13th Warrior
  # FIXME? - will titles ever include brackets?
  _directory="${_directory##*/}"
  _title=${_directory%%\ \(*}

# FIXME - This sort of thing works on the command line but not in a script.  What the fuck.
  #\echo ----
  #[[ "(1234" =~ \([0-9][0-9][0-9][0-9] ]]
  #\echo -${BASH_REMATCH[0]}-
  #\echo ----
}

  # Get the year,  e.g.  1999
#echo 2 ${A#*\(}
  # Get additional information
  #                e.g.  spoken language .eng
  #                      hard subtitles
  #                      b&w  (black and white)
  #                      sepia (monochrome - sepia-tone)
  #                      short film



_process_directory_contents() {
  # Process additional information within the directory:
  #   e.g. See also
  #        Remake of
}



_echo_content() {
  #  +=  is concatenation introduced in bash 3.1
  _output+="<li>"
  _output+="("
  # Note that I don't appear to need to convert spaces to underscores or the like..
  _output+="<a href=\"https://en.wikipedia.org/wiki/$_title\">wikipedia</a>"
  _output+=")"
  _output+=" $_title"
  _output+="</li>\n"
}



_teardown() {
  \echo  -n  $_output  >>  $_textfile
  \echo  TEXTFILE BEGINS
  \cat  $_textfile
  \echo  TEXTFILE ENDS
  \rm  --force  $_textfile
  \rmdir  $_tempdir/*
  \rmdir  $_tempdir
  \ls  -al  /tmp/tmp.*--movie-list-builder
}



_setup
_process_directory_name
_process_directory_contents
_echo_content
_teardown
