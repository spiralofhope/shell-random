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



;delay_keydown := 170
;delay_keyup := 159
delay_keydown := 70
delay_keyup := 70



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



$F3::
{
  ;MsgBox "F3 pressed by you!"
  if !WinExist( "ahk_exe dis1_st.exe" )
  {
    MsgBox "Disgaea not found!"
    return
  }
  WinActivate "ahk_exe dis1_st.exe"
  WinWaitActive "ahk_exe dis1_st.exe", , 2
  if !WinActive( "ahk_exe dis1_st.exe" )
  {
    MsgBox "Failed to activate Disgaea!"
    return
  }
  ;MsgBox "works"
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Enter Valgipus IV
  Sleep 3500  ; Wait to enter the area
  Sleep( delay_keydown ), Send( "{e down}" ), Sleep( delay_keyup ), Send( "{e up}" ) ; Go to the base panel or first unit
  Sleep( delay_keydown ), Send( "{l down}" ), Sleep( delay_keyup ), Send( "{l up}" ) ; Return unit to base
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Enter base panel
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Select first unit
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" )
  Sleep( delay_keydown ), Send( "{w down}" ), Sleep( delay_keyup ), Send( "{w up}" )
  Sleep( delay_keydown ), Send( "{a down}" ), Sleep( delay_keyup ), Send( "{a up}" )
  Sleep( delay_keydown ), Send( "{a down}" ), Sleep( delay_keyup ), Send( "{a up}" )
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Move execute
  Sleep 750  ; Wait for the movement animation.
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; That unit's menu
  Sleep( delay_keydown ), Send( "{s down}" ), Sleep( delay_keyup ), Send( "{s up}" )
  Sleep( delay_keydown ), Send( "{s down}" ), Sleep( delay_keyup ), Send( "{s up}" )
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Special menu
  Sleep( delay_keydown ), Send( "{s down}" ), Sleep( delay_keyup ), Send( "{s up}" )
  Sleep( delay_keydown ), Send( "{s down}" ), Sleep( delay_keyup ), Send( "{s up}" )
  Sleep( delay_keydown ), Send( "{s down}" ), Sleep( delay_keyup ), Send( "{s up}" )
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Select: Sword > Winged Slayer
  Sleep( delay_keydown ), Send( "{a down}" ), Sleep( delay_keyup ), Send( "{a up}" ) ; Target Winged Slayer at the group of 9
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Confirm target
  Sleep( delay_keydown ), Send( "{i down}" ), Sleep( delay_keyup ), Send( "{i up}" ) ; Action menu
  Sleep( delay_keydown ), Send( "{k down}" ), Sleep( delay_keyup ), Send( "{k up}" ) ; Execute
  Sleep 3500  ; Wait for the round end animation to begin.
  Sleep( delay_keydown ), Send( "{l down}" ), Sleep( delay_keyup ), Send( "{l up}" ) ; Stop the reward counter
  Sleep( delay_keydown ), Send( "{l down}" ), Sleep( delay_keyup ), Send( "{l up}" ) ; Exit reward screen
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
