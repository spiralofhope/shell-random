@ECHO OFF

::  For each directory and file found, make a symlink to a specified directory.
::
::  Tested 2016-02-11 on Windows 10, updated recently.
::
::    http://blog.spiralofhope.com/13539



::  This requires a trailing slash.
SET  "SOURCE=%~dp0"
SET  "TARGET=C:\Users\user\"



NET FILE 1>NUL 2>NUL & IF ERRORLEVEL 1 (
  ECHO Right-click and run this as administrator.
  PAUSE
  EXIT /B
)



CD %SOURCE%
::  Directories
FOR  /D  %%i  in  ( *.* )  DO (
  ECHO    * Processing %SOURCE%%%i
  ECHO                 %TARGET%%%i
  mklink  /J          "%TARGET%%%i"  "%SOURCE%%%i"
)
::  Files
FOR      %%i  in  ( *.* )  DO (
  IF NOT  "%%i"=="go.cmd"  (
    ECHO  * Processing %SOURCE%%%i
    ECHO               %TARGET%%%i
    mklink            "%TARGET%%%i"  "%SOURCE%%%i"
  )
)
