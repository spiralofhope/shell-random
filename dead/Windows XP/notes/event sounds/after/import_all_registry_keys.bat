@ECHO OFF

for %%i in (*.reg) do (
  reg IMPORT "%%i"
)

pause
