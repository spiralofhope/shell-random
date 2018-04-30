@ECHO OFF


SET  SOURCE="%~dp0_dotfiles\Diablo III"
SET  TARGET="C:\Users\user\Documents\Diablo III"



NET FILE 1>NUL 2>NUL & IF ERRORLEVEL 1 (
  ECHO Right-click and run this as administrator.
  PAUSE
  EXIT /B
)



%SOURCE:~1,2%
CD %SOURCE%
mklink  /J  %TARGET%  %SOURCE%
