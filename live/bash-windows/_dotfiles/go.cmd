@ECHO OFF

::  For each directory and file found, make a symlink to a specified directory.
::
::  Tested 2016-01-31 on Windows 10, updated recently.
::
::    http://blog.spiralofhope.com/13539



::  I have no idea why this won't work:
::  It does work at the commandline (run as admin) but not from windows explorer if I run this go.cmd script that way.
::SET  "SOURCE=%CD%"
SET  "SOURCE=C:\l\live\_dotfiles\Users_username"
SET  "TARGET=C:\Users\user"



:: BatchGotAdmin
::   http://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
::   https://sites.google.com/site/eneerge/scripts/batchgotadmin
::   http://blog.spiralofhope.com/13553
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------



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
