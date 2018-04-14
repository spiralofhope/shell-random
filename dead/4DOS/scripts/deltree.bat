GOTO _endnotes_

Prune an entire tree and all its files. 


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


Why use a program when you can write a batch file!  =)

Really, a program can be so much faster if it is intelligent.
Keep in mind that del does a file-by-file approach, where a
directory pruning program can cut corners.

* See also the delme batch.  While there are some subtle differences,
I don't want to combine the two scripts yet.

Check for a .* version of the directory, so that I can
manage the archive better.

:_endnotes_


ON BREAK (ECHO Breaking out!^QUIT)
SETLOCAL

: The quotes are to handle long filenames.
SET TEMPVAR="%1"

CDD %TEMPVAR
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
