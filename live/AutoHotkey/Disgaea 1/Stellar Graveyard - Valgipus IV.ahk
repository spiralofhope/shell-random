#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
;#Warn  ; Enable warnings to assist with detecting common errors.
; For the game:       Disgaea 1 (Steam)
; For the area:       Stellar Graveyard > Valgipus IV
; Using the ability:  see activate_ability()
; Grinding for:       HL (money)
;                     and for that character:  selected weapon, selected spell skill, exp, mana
;
; Begins at the menu, before entering into Valgipus IV.
; This is meant for one-shotting the whole group of nine enemies.
; Consider having Armsmaster dots for that character.
; This fails gracefully if you run out of mana.



; User-configuration:
delay_keydown := 85
delay_keyup   := 75
activate_ability() {
  ;staff_tera_fire()
  ;staff_tera_wind()
  ;staff_tera_ice()
  staff_tera_star()
  ;sword_winged_slayer()
}
executable := "ahk_exe dis1_st.exe"
autohotkey_window := "ahk_class #32770"



; ----


; Clear any MsgBox or error dialogs on startup
ClearDialogs()
{
  while WinExist( autohotkey_window )
  {
    WinClose autohotkey_window
    Sleep 100  ; Pause to allow closure
  }
}
ClearDialogs()



key( key, times := 1 )
{
  Loop times
  {
    Send( "{" . key . " down}" )
    Sleep( delay_keydown )
    Send( "{" . key . " up}" )
    Sleep( delay_keyup )
  }
}



spell_select()
{
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
  ; select next
}



spell_target()
{
  key( "k" )
  key( "d" )
  key( "d" )  ; square of 9
  key( "k" )
  key( "w" )
  key( "a" )
  key( "a" )
  key( "a" )
  key( "a" )  ; Target the group of 9
}



staff_tera_fire()
{
  spell_select()
  key( "s", 4 )
  spell_target()
}



staff_tera_wind()
{
  spell_select()
  key( "e" )
  key( "s" )
  spell_target()
}



staff_tera_ice()
{
  spell_select()
  key( "e", 2 )
  key( "w", 2 )
  spell_target()
}



staff_tera_star()
{
  spell_select()
  ;key( "s", 19 )  ; From the top going down
  ;key( "w", 10 )  ; From the bottom going up
  ;key( "e", 2 ), key( "s", 3 );  Hoping down
  ; Fastest method:
  key( "w" )
  key( "q" )
  key( "w" )
  spell_target()
}



move_in_front()
{
  key( "k" )  ; Move
  key( "w" )
  key( "a" )
  key( "a" )
  key( "k" )  ; Move execute
  Sleep 750   ; Wait for the movement animation.
}



sword_winged_slayer()
{
  move_in_front()
  key( "k" )  ; That unit's menu
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
  key( "s", 3 )  ; Sword > Winged Slayer
  key( "k" )
  key( "a" )  ; Target the group of 9
}



$F1::
{
  ;MsgBox "F1 pressed by you!"
  if !WinExist(  executable )
  {
    MsgBox "Disgaea not found!"
    return
  }
  WinActivate    executable
  WinWaitActive  executable, , 2
  if !WinActive( executable )
  {
    MsgBox "Failed to activate Disgaea!"
    return
  }
  ;MsgBox "works"
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
  Sleep 3600  ; Wait for the round end animation to begin.
  key( "l" )  ; Stop the reward counter
  key( "k" )  ; Exit reward screen
}



; Auto-reload when this file is edited.
initialTime := FileGetTime( A_ScriptFullPath, "M" )
SetTimer CheckFileChange, 2000
CheckFileChange()
{
  currentTime := FileGetTime( A_ScriptFullPath, "M" )
  if ( currentTime != initialTime )
  {
    Reload
    Sleep 2000
    MsgBox "Reload failed!"
  }
}
