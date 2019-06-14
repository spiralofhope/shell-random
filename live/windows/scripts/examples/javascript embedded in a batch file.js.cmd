:: Last tested 2014-11-07 or earlier, likely on Windows XP.



@set  @junk=1 /*
  @ECHO  OFF
  ::  cscript causes this file ( %0 ) to be executed by JSCRIPT with the same arguments ( %* )
  cscript.exe  //nologo  //E:jscript  %0  %*
  ::  :eof is a builtin label that represents the end of file.
  GOTO  :eof
*/


//  --
//  batch file > javascript
//  --
WScript.echo( 'Hello, world!' )

// pausing the  batch file > javascript
var shell = WScript.CreateObject( 'WScript.Shell' )
shell.Run( 'choice /C YN  /D Y  /N  /T 1' )


//  --
//  batch file > javascript > shell commands
//  --
var shell = new ActiveXObject( 'WScript.Shell' )
shell.run( 'cmd /c dir & pause' );

// Alternates to wait 1 second:
// shell.Run( 'ping -n 2 127.0.0.1' )
// shell.Run( 'TIMEOUT  /NOBREAK  /T 2' )

// FIXME - I don't know how to suppress output.  Something like this fails completely:
// shell.Run( 'TIMEOUT  /NOBREAK  /T 2  > NUL' )
