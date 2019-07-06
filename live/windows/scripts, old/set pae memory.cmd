@ECHO OFF

::  Set PAE to use all available memory.
::
::  Tested 2014-10-13 on Windows 8.1, updated recently.
::   http://msdn.microsoft.com/en-us/library/windows/hardware/ff542202(v=vs.85).aspx
::   http://msdn.microsoft.com/en-us/library/windows/hardware/ff542275(v=vs.85).aspx

:: Fuck, this won't work.
:: The pae parameter is valid only on boot entries for 32-bit versions of Windows that run on computers with x86-based and x64-based processors.



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



bcdedit.exe  /set pae forceenable
