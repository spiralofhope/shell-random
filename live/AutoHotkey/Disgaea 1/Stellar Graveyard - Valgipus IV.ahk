#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
;#Warn  ; Enable warnings to assist with detecting common errors.

; - For the game:       Disgaea: Hour of Darkness (Steam)
;                         - This is the port of the original 2003 PS/2 game, aka "Disgaea 1"
; - For the area:       Stellar Graveyard > Valgipus IV
; - Using the ability:  see activate_ability()
; - Grinding for:       HL (money)
;                         - That character also gains:  Selected weapon skill, Selected spell skill, EXP, MANA
; 
; - Begins at the menu, before entering into Valgipus IV.
; - Uses the first character in your party, but is easily customized.
; - This is meant for one-shotting the whole group of nine enemies.
; - Consider having Armsmaster dots for that character.
; - This fails gracefully if you run out of mana via a happy accident.
; - Note that this lays the foundation for any sort of automation for any application, and is not limited to Disgaea 1.
; - Further in are hard-coded delays using the "Sleep" command which you can customize if your system runs the Disgaea 1 slower than intended.



; User-configuration:
miliseconds_holding_a_key_down := 85
delay_between_keystrokes := 75
activate_ability() {
  ; - Choose only one ability.
  ; - This script is designed for a 9x9 ability which is guaranteed to one-shot and clear the stage.
  ; - However, if you are unable to fulfill that requirement, this script is designed to be easily customized, even to the point of letting you control multiple characters.
  ;   - Beware that if you clear the stage yet the script assumes it needs to control additional characters, you will have a mess on your hands.  Try having multiple characters attack different sections of the group, and follow it up with a 9x9.  This was how I did my original grinding for little characters.

  ;staff_tera_fire()
  ;staff_tera_wind()
  ;staff_tera_ice()
  staff_tera_star()
  ;sword_winged_slayer()
}
executable := "ahk_exe dis1_st.exe"
; Maybe this would change under some circumstances, perhaps with a future update to AutoHotKey?
; If needed, use the "Window Spy" command via right-clicking your AutoHotKey tray icon to learn the details of an AutoHotKey dialog.
autohotkey_window := "ahk_class #32770"



; ----



; Clear any MsgBox or error dialogs on startup.
; This lets you make mistakes with your on-the-fly script edits.  Just correct your mistakes and save again, and this script will automatically clear the explosion of errors for you.
ClearDialogs() {
  while WinExist( autohotkey_window ) {
    WinClose      autohotkey_window
    Sleep 100  ; Pause to allow closure
  }
}
ClearDialogs()



key( key, times := 1 ) {
  Loop times {
    ; The theory was to ensure that the application is focused at every keystroke.  In practice, it does not work.
    ;focus_application()
    Send( "{" . key . " down}" )
    Sleep( miliseconds_holding_a_key_down )
    ;focus_application()
    Send( "{" . key . " up}" )
    Sleep( delay_between_keystrokes )
  }
}



spell_select() {
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
}



spell_target() {
  key( "k" )
  key( "d" )
  key( "d" )  ; Select the square of 9
  key( "k" )
  key( "w" )
  key( "a" )
  key( "a" )
  key( "a" )
  key( "a" )  ; Target the group of 9
}



staff_tera_fire() {
  spell_select()
  key( "s", 4 )
  spell_target()
}



staff_tera_wind() {
  spell_select()
  key( "e" )
  key( "s" )
  spell_target()
}



staff_tera_ice() {
  spell_select()
  key( "e", 2 )
  key( "w", 2 )
  spell_target()
}



staff_tera_star() {
  spell_select()
  ;key( "s", 19 )  ; From the top going down
  ;key( "w", 10 )  ; From the bottom going up
  ;key( "e", 2 ), key( "s", 3 );  Hopping down
  ; Fastest method:
  key( "w" )
  key( "q" )
  key( "w" )
  spell_target()
}



; Move directly in front of the block of 9 enemies.
move_in_front() {
  key( "k" )  ; Move
  key( "w" )
  key( "a" )
  key( "a" )
  key( "k" )  ; Move execute
  Sleep 750   ; Wait for the movement animation.
}



sword_winged_slayer() {
  move_in_front()
  key( "k" )  ; That unit's menu
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
  key( "s", 3 )  ; Sword > Winged Slayer
  key( "k" )
  key( "a" )  ; Target the group of 9
}



focus_application() {
  if !WinActive(   executable ) {
    WinActivate    executable
    WinWaitActive  executable, , 2  ; Delay the script for up to 2 seconds.
  }
  if !WinActive(   executable ) {
    MsgBox "Failed to focus the application:  " . executable
    ExitApp
  }
}



$F1:: {
  focus_application()
  key( "k" )  ; Enter Valgipus IV
  Sleep 3500  ; Wait to enter the area
  key( "e" )  ; Go to the base panel or first unit
  key( "l" )  ; Return unit to base
  key( "k" )  ; Enter base panel
  key( "k" )  ; Select first unit
  activate_ability()
  key( "k" )  ; Confirm target
  key( "i" )  ; Action menu
  key( "k" )  ; Execute
  Sleep 3600  ; Wait for the stage end animation to begin.
  key( "l" )  ; Stop the reward counter
  key( "k" )  ; Exit reward screen
}



; Auto-reload this script when its file is edited.
initialTime   := FileGetTime( A_ScriptFullPath, "M" )
SetTimer CheckFileChange, 2000
CheckFileChange() {
  currentTime := FileGetTime( A_ScriptFullPath, "M" )
  if ( currentTime != initialTime ) {
    Reload
    Sleep 2000
    MsgBox "Reload failed!"
  }
}
