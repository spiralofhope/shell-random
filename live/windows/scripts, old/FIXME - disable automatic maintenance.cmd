@ECHO OFF

::  Disable Windows automatic maintenance.
::
::  Tested 2014-10-02 on Windows 8.1, updated recently.

SET  "_SYS=C:\SysinternalsSuite"


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



"%_SYS%\PsExec.exe"  -s schtasks.exe  /change  /tn "\Microsoft\Windows\TaskScheduler\Maintenance Configurator"  /DISABLE

::  FIXME - I get:
:: Error establishing communication with PsExec service on dimstar:
:: A device attached to the system is not functioning.

::  test the servername with
::    ping  dimstar

:: there is also
::   net use \\%USERDOMAIN%

PAUSE

Troubleshooting:

sc query psexesvc

run > 
C:\Windows\System32\Tasks\Microsoft\Windows\TaskScheduler\
Right click  Maintenance Configurator > Properties > Security > [Advanced]
Click Change next to Owner
In the Select User or Group type Users in the box and press the Check Names button
Click OK three times to close all windows.
Right click  Maintenance Configurator > Properties > Security > [Edit]
Select Administrators and check Full control under the Allow column
Click OK, click Yes, click OK

run >
%windir%\system32\taskschd.msc /s
In the middle column, scroll down and find "Active Tasks" and then "Maintenance Configurator"
On the right column, click "Disable".

These instructions do not make sense to me.  Shouldn't it be "Regular Maintenance" that I'm changing?

Can't I just disable regular maintenance manually?  I'm testing that.
