GOTO _endnotes_

Delete the current directory.


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


Modifications and upgrades with help from batch programmers
all over the place (thanks!).  DOS addition by Marcus Eckert 1995-11-18.

v2.0

add in a switch such that delme will only remove blank dirs
 
? The DOS version does not work with subdirectories!!

** DOES NOT WORK IN WINDOWS PROPERLY!!! only with blank dirs...  =(

?? Make a little modification?  "IF EXIST ..\%_cwd.*" ?
	I keep on accidentally using tab-completion and getting .zip or .rar
	etc...  it would be nice to cover that..  I suppose.  =/

- Long filename supporting (needs to be rechecked)
- handles files in subdirs, including hidden dirs or files

:_endnotes_


IF NOT %@EVAL[1+1]==2 GOTO _dos_
IF .%1!=. GOTO _end_

ON BREAK (ECHO Breaking out!^QUIT)
: Cannot SETLOCAL because if the user does not abort, I don't want
: the ugly broken cdd to happen when it tries to get into a missing dir
UNSET /Q TEMPVAR $A

: The quotes are to handle long filenames.
SET TEMPVAR="%_cwd"

: Check to see if there are any files THEN Delete the dir
: If the user aborted the delete, go back in.
GLOBAL /H /I /Q IF EXIST *.* SET $A=1
IFF %$A=1 THEN
	 ..\
	*DEL/ESXZ %TEMPVAR
ELSE
	: If no files/dirs were found, remove the directory (no y/n prompt)
	: The normal error messages are surpressed
	ECHO Removing the Blank Directory
	..\
	*DEL/ESYX %TEMPVAR
ENDIFF

: If the user aborted at any point, or if there's a problem, CD back in.
IF ISDIR %TEMPVAR CD %TEMPVAR
UNSET /Q TEMPVAR $A
GOTO _end_

:_dos_
SET CD=$p
IF .%1==. GOTO _go_
PROMPT SET CD=$p
ECHO ON
GOTO _end_

:_go_
C:\DOS\command.com/E:32768 /F /P /C %0 42>delcd$$$.bat
CALL delcd$$$.bat
DEL delcd$$$.bat
:  ^ may not be needed  (??)
CD..
attrib.exe -H %CD%
DEL %CD%
RD %CD%
SET CD=

:_end_
