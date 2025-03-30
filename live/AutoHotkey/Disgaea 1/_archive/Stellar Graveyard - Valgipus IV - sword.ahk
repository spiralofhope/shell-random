; For the game:       Disgaea 1 (Steam)
; For the area:       Stellar Graveyard > Valgipus IV
; Using the ability:  Sword > Winged Slayer
; Grinding for:       HL (money) and for that character:  Sword skill, Winged Slayer skill, exp, mana.
;
; Begins at the menu, before entering into Valgipus IV.
; This works best when you can one-shot the whole group of nine enemies.
; Consider having Armsmaster dots for that character.

#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
; #Warn  ; Enable warnings to assist with detecting common errors.



delay_keydown := 80
delay_keyup   := 70
executable := "ahk_exe dis1_st.exe"


initialTime := FileGetTime( A_ScriptFullPath, "M" )
SetTimer CheckFileChange, 2000


; Clear any MsgBox or error dialogs on startup
ClearDialogs()
{
  while WinExist( "ahk_class #32770" )
  {
    WinClose "ahk_class #32770"
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
  key( "k" )  ; Move
  key( "w" )
  key( "a" )
  key( "a" )
  key( "k" )  ; Move execute
  Sleep 750   ; Wait for the movement animation.
  key( "k" )  ; That unit's menu
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
  key( "s", 3 )  ; Sword > Winged Slayer
  key( "k" )
  key( "a" )  ; Target the group of 9
  key( "k" )  ; Confirm target
  key( "i" )  ; Action menu
  key( "k" )  ; Execute
  Sleep 3600  ; Wait for the round end animation to begin.
  key( "l" )  ; Stop the reward counter
  key( "k" )  ; Exit reward screen
}



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
