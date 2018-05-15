goto _old_notes
This used to work on a traditional XP system.
This stopped working properly on Windows Fundamentals for Legacy PCs

for /f "tokens=1,2,3 delims=/ " %%a in ("%date%") do (
   set day=%%a
   set month=%%b
   set year=%%c
)

This was when I manually set the Windows internal date system to yyyy-mm-dd during installation.

for /f "tokens=1,2,3 delims=- " %%a in ("%date%") do (
   set year=%%a
   set month=%%b
   set day=%%c
)
:_old_notes

---

: This leaves the window open:
: cmd /C "C:\Program Files\Geany\bin\geany.exe" texts\*.txt
: This does not:
: start C:\"Program Files\Geany\bin\geany.exe" texts\*.txt


goto _endnotes_
a heredoc, of sorts:

out.txt (
	echo line1
	echo line2
)
:_endnotes_


echo ok

-------------------

GOTO _endnotes_
This is for an unmodified copy of windows
for /f "tokens=1,2,3,4 delims=/ " %%a in ("%date%") do (
   set weekday=%%a
   set month=%%b
   set day=%%c
   set year=%%d
)

for /f "tokens=1,2 delims=:." %%a in ("%time%") do (
   set hour=%%a
   set minute=%%b
)
set mydate=%year%-%month%-%day%
set mytime=%hour%-%minute%
:_endnotes_

---------------

# Note that you could also do stuff like
#   echo %var:from=to%
#   echo %date:/=-%
