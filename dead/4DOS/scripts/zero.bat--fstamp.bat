GOTO _endnotes_

to create zero-byte files.
This is the old stuff, with fstamp.exe [fstmp131]


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


:_endnotes_


SETLOCAL
IF %@ATTRIB[%1,R,P]=1 (C:\UTILS\TBAV\tbfile.exe D^ATTRIB -R %1^C:\UTILS\TBAV\tbfile.exe D^SET A=1)

IFF "%1"="0" THEN
	TOUCH /D:0-0-0 /T:0:0:0 %2&
ELSEIFF "%1"="00" THEN
	C:\UTILS\fstamp.exe /M:C:\BATCHES\zero %2&
ELSE
	TOUCH /D:01-01-80 /T:00:00:00 %1
ENDIFF

IF %A=1 (ATTRIB +R %1^SET A=)
ENDLOCAL
