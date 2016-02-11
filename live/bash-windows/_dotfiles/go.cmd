@ECHO OFF

::  For each directory and file found, make a symlink to a specified directory.
::
::  Tested 2016-02-11 on Windows 10, updated recently.
::
::    http://blog.spiralofhope.com/13539



SET  "SOURCE=%~dp0"
SET  "TARGET=C:\Users\user"



:: ----
:: Elevate privileges
:: ----
::   http://blog.spiralofhope.com?p=13553
::   https://stackoverflow.com/questions/7044985
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*
exit /B

:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0
:: ----



::  Directories
FOR  /D  %%i  in  ( *.* )  DO (
  ECHO  * Processing %SOURCE%\%%i
  ECHO               %TARGET%\%%i
  mklink  /J        "%TARGET%\%%i"  "%SOURCE%\%%i"
)
::  Files
FOR      %%i  in  ( * )  DO (
  IF NOT  "%%i"=="go.cmd"  (
    ECHO  * Processing %SOURCE%\%%i
    ECHO               %TARGET%\%%i
    mklink            "%TARGET%\%%i"  "%SOURCE%\%%i"
  )
)
