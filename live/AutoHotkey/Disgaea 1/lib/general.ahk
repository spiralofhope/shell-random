key( key, times := 1 ) {
  Loop times {
    ; The theory was to ensure that the application is focused at every keystroke.  In practice, it does not work.
    ;focus_application()
    kill_script_if_executable_not_focused()
    Send( "{" . key . " down}" )
    Sleep( milliseconds_holding_a_key_down )
    ;focus_application()
    Send( "{" . key . " up}" )
    Sleep( delay_between_keystrokes )
  }
}



focus_application() {
  if !WinActive(   executable ) {
    WinActivate    executable
    ; Delay this script for up to 2 seconds to wait for the system to switch to the executable's window (i.e. an alt-tab).
    ; Lua-style empty variable
    WinWaitActive  executable,  , 2
  }
  if !WinActive(   executable ) {
    MsgBox "Failed to focus the application:  " . executable . "`nreloading this script."
    Reload
  }
}



kill_script_if_executable_not_focused() {
  if !WinExist( executable ) {
    MsgBox "Executable not found:  " . executable . "`nexiting this script."
    ExitApp
  }
}
