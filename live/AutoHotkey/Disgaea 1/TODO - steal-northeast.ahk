; UNFINISHED / UNTESTED



; - Consider having Marksmen dots for that character for +Hit.
; - A high level rogue is needed, otherwise you'll only have a 1% chance.  This Autohotkey script is made for that circumstance.
; - Further in are hard-coded delays using the "Sleep" command which you can customize if your system runs the Disgaea 1 slower than intended.
; - While this uses the F1 hotkey, that can be configured below.



#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
;#Warn  ; Enable warnings to assist with detecting common errors.



; User-configuration:
milliseconds_holding_a_key_down := 85
delay_between_keystrokes := 75
steal_northeast() {
  ; - Choose only one ability.
;  key( "e" )  ; Go to the base panel or first unit
;  key( "l" )  ; Return unit to base
;  key( "k" )  ; Enter base panel
;  key( "k" )  ; Select first unit
  key( "k" )  ; That unit's menu

  first_item_select()
  target_northeast()
  key( "k" )  ; Activate Steal ability
  key( "k" )  ; (Attempt to) Steal first item
}



steal() {
;  key( "e" )  ; Go to the base panel or first unit
;  key( "l" )  ; Return unit to base
;  key( "k" )  ; Enter base panel
  key( "k" )  ; Select first unit

  first_item_select()
}

first_item_select() {
  key( "w", 3 )  ; Item
  key( "k" )     ; Enter item menu
  key( "k" )     ; Select first item
}
target_northeast() {
  key( "w" )
}


loop_number_of_times := 1

; F1 as a hotkey to run the script
$F1:: {
    ; Bugged - If 10, this iterates 7 times.
    Loop loop_number_of_times {
    if !WinExist( executable ) {
      MsgBox "Executable not found:`n" . executable
      Reload
    }
    ; I don't know why this doesn't work:
    ;ClearDialogs()
    focus_application()
    steal_northeast()
    end_turn()
  }
}



executable := "ahk_exe dis1_st.exe"
; Maybe this would change under some circumstances, perhaps with a future update to AutoHotKey?
; If needed, use the "Window Spy" command via right-clicking your AutoHotKey tray icon to learn the details of an AutoHotKey dialog.
autohotkey_window := "ahk_class #32770"



; Auto-reload this script (and its dependencies) when this file is edited.
; I'm not going to bother determining if any libraries get modified.
script_timestamp_initial   := FileGetTime( A_ScriptFullPath, "M" )
SetTimer check_for_timestamp_change, 2000
check_for_timestamp_change() {
  script_timestamp_current := FileGetTime( A_ScriptFullPath, "M" )
  if ( script_timestamp_current != script_timestamp_initial ) {
    Reload
  }
}



; These are down here because variables are set above.
; Their order is unimportant because of the structure of this scripting.
#Include "lib\general.ahk"

#Include "lib\weapon skills\Combat.ahk"
#Include "lib\weapon skills\Sword.ahk"
#Include "lib\weapon skills\Spear.ahk"
#Include "lib\weapon skills\Bow.ahk"
#Include "lib\weapon skills\Gun.ahk"
#Include "lib\weapon skills\Axe.ahk"
#Include "lib\weapon skills\Staff.ahk"
#Include "lib\weapon skills\Monster only.ahk"
#Include "lib\character skills\Laharl.ahk"

; The #Include command does not support variables; this must be hard-coded for your area of interest.
#Include "lib\areas\Stellar Graveyard\Valgipus IV\movement.ahk"
