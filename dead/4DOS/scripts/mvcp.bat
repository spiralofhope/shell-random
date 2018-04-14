GOTO _endnotes_


not sure. some kind of move and copy helper. 


2018-04-13
  --  This is at least as old as 2007-07-22, and I know it's *much* older.
  --  I have not come across an earlier version of this script.  Perhaps one day.


helper scripts:

mv.bat

 SET $MVCP=MV
 CALL %8086%\BATCHES\mvcp.bat %&

cp.bat

 SET $MVCP=CP
 CALL %8086%\BATCHES\mvcp.bat %&


be able to move ..\foo .
or move ..\foo
such that foo is a dir.

be able to move ..\*.* <> and have it skip the %_cwd so that
it won't error out.  Have the wildcard manually handled such
that certain dirs can be skipped.  Use [@LIST]

be able to move the cwd while in it

Unix-style directory moving  and copying

Unfortunately, for unknown reasons, i can neither have this 
called from an alias, nor have said alias set a variable so 
that mv and cp can use the same code.  Fuck.  The kludge is
to have a mv and cp batch file.  Eesh..

problem: cannot move .. . or . .. because %1 and %2 are both
directories.  Just mask those commands out.

in the far future:
if exist %2, compare size, if same, do a byte compare (does
4dos have an internal function, or will I have to use an
outside program?)
if %1 = %2, delete %2
* deal with the descriptions.. keep %2's description
(deal with wildcards)

:_endnotes_


: Manually change the copy/move statements
IF %$MVCP=CP SET $MVCP=`*COPY /A: /B /K /R /Z`
IF %$MVCP=MV SET $MVCP=`*MOVE /A: /R`

: Deal with wildcards
IF %@INDEX[%&,*] != -1 .OR. %@INDEX[%&,?] != -1 (%$MVCP %&^UNSET /Q $MV^QUIT)

IFF ISDIR "%1" .AND. ISDIR "%2" THEN
	IFF ISDIR "%2"\"%1"\ THEN
	: For some reason, mv . .. will call this routine.
	: cp \ .  calls this too.  bad
	? "Destination directory exists.. merge?" (IFF EXIST "%1"\*.* THEN ATTRIB -R /S "%2"\"%1"\*.*^%$MVCP /S "%1"\*.* "%2"\"%1"\^ELSE ECHO Source is blank, removing it...^RD "%1"^ENDIFF)^QUIT
	ELSE 
	*MD /S "%2"\"%1"\
	%$MVCP /S "%1"\*.* "%2"\"%1"\
	ENDIFF
ELSE
	: Deal with the target file being read-only.
	: I'm not sure how to properly find the last variable.
	: So i use %2..  =(
	IFF ".%3"="." THEN
		IF %@ATTRIB["%2",r,p]=1 ATTRIB -R "%2"
		%$MVCP %&
	ELSE
		: Insert intelligence about the destination being ro
		: I can't tell which switch is last
		echo %$MVCP %&
	ENDIFF
ENDIFF
UNSET $MVCP
