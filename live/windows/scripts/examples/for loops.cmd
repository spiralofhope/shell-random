@ECHO  OFF



:: Work on directories.
FOR  /D  %%i  in  ( *.* )  DO (
  ECHO  " * Processing %%i"
)



:: Work on files in some odd way.
FOR  /F  %%i  in  ( 'DIR /AD /B' )  DO (
  ECHO  " * Processing %%i"
)
