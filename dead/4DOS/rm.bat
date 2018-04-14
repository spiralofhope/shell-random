GOTO _endnotes_


More intelligent removal of files, to include directories..


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


:_endnotes_


IFF ".%2"="."  THEN
	IFF ISDIR %1 THEN
		CALL %8086%\BATCHES\deltree.bat %1
	ELSE
		*DEL /Z %1
	ENDIFF
ELSE
	*DEL /Z %&
ENDIFF
