; QTTabBar
;   http://qttabbar.wikidot.com/
;   https://blog.spiralofhope.com/?p=8216

; Version 1040 cannot have multiple key combinations assigned to the same function.
; This brute-forces the remapping of key combinations.



#IfWinActive  ahk_exe  explorer.exe



^PgDn::^Tab     ; control-pagedown = control-tab
^PgUp::^+Tab    ; control-pageup   = control-shift-tab


; So the above doesn't interfere with normal operation:

^+PgDn::^+PgDn
^+PgUp::^+PgUp



#IfWinActive
