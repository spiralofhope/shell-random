GOTO _endnotes_


For 'super snooper'.


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


This needs to be windows aware, since the program is
windows aware.

:_endnotes_


IFF %@ATTRIB[%1,R,P]=1 THEN
	%8086%\UTILS\TBAV\tbfile.exe d
	ATTRIB/Q -R %1
	%8088%\UTILS\ss.exe %&|more
	ATTRIB/Q +R %1
	%8086%\UTILS\TBAV\tbfile.exe e
ELSE
	%8088\UTILS\ss.exe %&|more
ENDIFF
