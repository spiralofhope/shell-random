@ECHO  OFF



:: Search/replace.
::   http://stackoverflow.com/questions/5273937/how-to-replace-substrings-in-windows-batch-file



SET  "SOURCE=C:\Users\user\Documents\My Games\Borderlands 2\WillowGame\Config\WillowGame.ini"
SET   TARGET=C:\Windows\Temp\search_replace.txt
SET    "SEARCH=FakePlatform=-1"
SET   "REPLACE=FakePlatform=1"   &::  Xbox360

:: SET   "REPLACE=FakePlatform=-1"  &::  PC (default)
:: SET   "REPLACE=FakePlatform=2"   &::  PS3



SETLOCAL  EnableDelayedExpansion
FOR  /F  "tokens=1*  delims=]"  %%j  IN  ( 'type "%SOURCE%" ^| FIND /V  /N  ""' ) DO (
  IF "%%k"=="" (
    echo.
    ECHO.>> %TARGET%
  ) ELSE (
    SET  string=%%k
    SET  "modified=!string:%SEARCH%=%REPLACE%!"
    ECHO !modified!
    ECHO !modified!>> %TARGET%
  )
)
ENDLOCAL



DEL  %SOURCE%
RENAME  %TARGET% %SOURCE%
