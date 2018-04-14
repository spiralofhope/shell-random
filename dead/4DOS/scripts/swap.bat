GOTO _endnotes_

For 'super snooper'.


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


Maybe i should throw in intelligence and deal with swapping a file with a dir?
naaw

:_endnotes_


IF %1.=. (ECHO The help goes here.. heh^QUIT)

IF NOT EXIST %1 .AND. NOT ISDIR %1 (ECHO %@TRUENAME[%1] Not Found^ECHO     0 directories swapped^QUIT)
IF NOT EXIST %2 .AND. NOT ISDIR %2 (ECHO %@TRUENAME[%2] Not Found^ECHO     0 directories swapped^QUIT)
SET TEMPVAR=%@UNIQUE[]
DEL/Q %TEMPVAR
REN/Q %1 %TEMPVAR
REN/Q %2 %1
REN/Q %TEMPVAR %2
ECHO %@TRUENAME[%1] `<-->` %@TRUENAME[%2]
ECHO     2 directories swapped
