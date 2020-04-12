@ECHO OFF

::  TODO - make instructions on uninstalling flash


::  Remove flash from the control panel
::
::  Tested 2014-10-16 on Windows 8.1, updated recently.
::  Requires a relog.


:: For some fucked up reason, this script can't be in a subdirectory.  Maybe the path is too long?


SET  "DIR=C:/Windows/SysWOW64"

:: BatchGotAdmin
:: http://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file
:: https://sites.google.com/site/eneerge/scripts/batchgotadmin
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



MOVE  /Y  %DIR%\FlashPlayerApp.exe     .\flash_removed\
MOVE  /Y  %DIR%\FlashPlayerCPLApp.cpl  .\flash_removed\
PAUSE
