GOTO _endnotes_

to create zero-byte files.


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


:_endnotes_


TOUCH/F /T00-00-00 /D00-00-0000 %&

QUIT

: other crap

: Uses the 4dos command "touch".
! %8086%\UTILS\TBAV\tbfile.exe d

IFF %1=0 THEN
	TOUCH/F /T01-01-80 /D00-00-0000 %&
ELSE
	TOUCH/F /T00-00-00 /D00-00-0000 %&
ENDIFF

! %8086%\UTILS\TBAV\tbfile.exe e

QUIT



