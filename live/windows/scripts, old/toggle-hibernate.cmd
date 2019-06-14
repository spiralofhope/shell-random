@ECHO OFF

:: Tested 2014-01-27 on Windows 8.1, updated recently.


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



IF EXIST c:\hiberfil.sys ( 
  powercfg.exe  -hibernate off
  ECHO Turned it off
) ELSE (
  powercfg.exe  -hibernate on
  ECHO Turned it on
) 	

PAUSE
