@ECHO OFF
:: Learn if this script does or does not have administrator access.
:: 2024-08-15 on Windows 11 Home
:: 2021-06-24 - Also tested back then



FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V




IF not (%adminTest%)==(Access) GOTO admin
ECHO not admin
GOTO end


:admin
ECHO admin


:end


PAUSE
