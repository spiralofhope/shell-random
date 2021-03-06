@ECHO  OFF

::  Windows Time service will still write local time to the RTC regardless of the registry setting on shutdown, so it is handy to disable Windows Time service with this command (if time sync is still required while in Windows use any third-party time sync solution):



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



sc.exe  config  w32time  start=disabled

::  To re-enable windows time service:
::  sc.exe  config  w32time  start=demand
