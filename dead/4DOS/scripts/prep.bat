GOTO _notes_


uh.. not really sure. 


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


Unfortunately, the drive letter should not be defined!
 -- Why?  The drive letter of what?

The body of the file prep.btm makes (the .###) could be imbedded as hidden text
within the description of the .###, and unc.btm could disassemble the
description of the .### in order to get the information.  This would make the
.### a 0 byte file, saving much space!

:_notes_
SETLOCAL
UNALIAS *
IF NOT %@INDEX[!-?!/?!?!,!%1!] != -1 GOTO _endnotes_
TEXT


This program prepares a duplicate file using the .### extension.
It duplicates the description as well.


It requires 4DOS
ENDTEXT
:_endnotes_


IF %@INDEX[!-?!/?!?!,!%1!] != -1 QUIT
IF NOT EXIST %1 THEN (ECHO.^ECHO ERROR: File Not Found^QUIT)
ECHO %@TRUENAME[%1]>%@NAME[%1].###
DESCRIBE %@NAME[%1].### "%@DESCRIPT[%1]
