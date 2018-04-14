GOTO _endnotes_

descript.ion helper to describe the current directory.


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


Describes the current dir.

See also renme.

Jeez.. this was trivial.. sigh.

To pass things to this like:
desme -->
must do as
desme --`>`
in order for it to show up

:_endnotes_


IFF ".%1"="." THEN
	*DESCRIBE %_CWD
ELSE
	*DESCRIBE %_CWD /D"%&"
ENDIFF
: Apparently I cannot echo the description of the directory
: with %@DESCRIPT[%_CWD] .. bullshit
: also broken:
: IF ".%1" NE "." ECHO %_CWD %1&
: fuck it..
