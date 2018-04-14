GOTO _endnotes_


Renames the current directory


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.



Based loosely on delme\deltree

LFN dirs with spaces would have to be received (%1) with quotes "like so"

:_endnotes_


UNSET /Q $A

: If no input.  I could stick help in here...
IF ".%1" = "." QUIT

: Broken?: This may not work on LFN sysytems if _cwd is not passed correctly
: if there are spaces.  It will probably work though..
SET $A=%_CWD
..\
IFF ISDIR %1 THEN
	ECHO That directory already exists.
ELSE
	: I may want to put in intelligence to deal with nonsense like
	: my desire to use ..\ and tab a similar dir, then edit the cmdline
	: Hmm.. I probably won't care to do that anyway.
	REN %$A %1
	CD %1
ENDIFF

: go back in if i aborted
IF ISDIR %$A CD %$A

UNSET /Q $A
