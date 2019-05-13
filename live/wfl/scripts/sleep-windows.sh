#!/usr/bin/env  sh
# Put Windows to sleep

# Usage example:
#   sleep 10m ; sleep-windows.sh




# Not reviewed:
# https://superuser.com/questions/39584
# https://superuser.com/questions/463646


#:<<'}'  # NirSoft
# http://www.nirsoft.net/utils/nircmd.html
{
  nircmdc.exe standby
}

:<<'}'  # Native, but not correct.
# https://superuser.com/questions/42124
# Note that this will hibernate if that's enabled.  To disable hibernation, do:
# powercfg -hibernate off
{
  rundll32.exe powrprof.dll,SetSuspendState 0,1,0

  # If you prefer hibernation, you would do:
  #powercfg -hibernate on
  #rundll32.exe powrprof.dll,SetSuspendState Hibernate
}



:<<'}'  # Untested
{
  # https://docs.microsoft.com/en-us/sysinternals/downloads/psshutdown
  psshutdown -d -t 0

  # https://www.autohotkey.com/
  # (It would need to be called from the commandline)
  sleep.ahk, whose contents would be:
  DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)

  # http://www.grc.com/wizmo/wizmo.htm
  wizmo standby

  # http://www.softpedia.com/get/System/Launchers-Shutdown-Tools/Sleep-Shortcut-for-Windows-10.shtml
  # source:  http://j.mp/sleeptt

  # Python (with pywin32)
  pythonw -c "import ctypes; ctypes.windll.PowrProf.SetSuspendState(0, 1, 0)"

  # a batch file:
  @echo off &mode 32,2 &color cf &title Power Sleep
  set "s1=$m='[DllImport ("Powrprof.dll", SetLastError = true)]"
  set "s2=static extern bool SetSuspendState(bool hibernate, bool forceCritical, bool disableWakeEvent);"
  set "s3=public static void PowerSleep(){ SetSuspendState(false, false, false); }';"
  set "s4=add-type -name Import -member $m -namespace Dll; [Dll.Import]::PowerSleep();"
  set "ps_powersleep=%s1%%s2%%s3%%s4%" 
  call powershell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -Command "%ps_powersleep:"=\"%"
  exit

  # As above, as a single commandline
  powershell.exe -C "$m='[DllImport(\"Powrprof.dll\",SetLastError=true)]static extern bool SetSuspendState(bool hibernate,bool forceCritical,bool disableWakeEvent);public static void PowerSleep(){SetSuspendState(false,false,false); }';add-type -name Import -member $m -namespace Dll; [Dll.Import]::PowerSleep();"

}
