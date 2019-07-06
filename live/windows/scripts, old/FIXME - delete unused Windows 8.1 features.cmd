@ECHO OFF

::  Remove unnecessary crap from Windows 8.1
::
::  Tested 2014-04-10 on Windows 8.1, updated recently.

:: FIXME - I get "access denied", perhaps because of Windows being updated or some such.


GOTO COMMENT
  Girish Rengaswamy, 2012-11-27
  http://techathlon.com/toggle-hibernate-bat-easily-delete-hiberfil-sys/
  (Distribution allowed but with attribution)
:COMMENT



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



cd "C:\Program Files (x86)\"
del  /F /S /Q  "Internet Explorer"
del  /F /S /Q  "Microsoft.NET"
del  /F /S /Q  "Windows Mail"
del  /F /S /Q  "Windows Multimedia Platform"
del  /F /S /Q  "Windows Photo Viewer"
del  /F /S /Q  "WindowsPowerShell"

PAUSE
