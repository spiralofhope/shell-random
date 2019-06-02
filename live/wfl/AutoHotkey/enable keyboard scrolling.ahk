#IfWinActive ahk_class ConsoleWindowClass


+PgUp::   ; shift-pageup
^PgUp::   ; control-pageup
Send {WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}
Return


+PgDn::   ; shift-pagedown
^PgDn::   ; control-pagedown
Send {WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}
Return


#IfWinActive
