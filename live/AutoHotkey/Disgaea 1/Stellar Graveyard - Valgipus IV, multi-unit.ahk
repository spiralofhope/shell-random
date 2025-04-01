#Requires AutoHotkey v2
#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
;#Warn  ; Enable warnings to assist with detecting common errors.

; VARIATION - The first party member casts one spell, the stage is cleared by the next party member.

; - For the game:       Disgaea: Hour of Darkness (Steam)
;                         - This is the port of the original 2003 PS/2 game, aka "Disgaea 1"
; - For the area:       Stellar Graveyard > Valgipus IV
; - Using the ability:  see clear_ability_activate()
; - Grinding for:       HL (money)
;                         - That character also gains:  Selected weapon skill, Selected spell skill, EXP, MANA
; 
; - Begins at the menu, before entering into Valgipus IV.
; - Uses the first character in your party, but is easily customized.
; - This is meant for one-shotting the whole group of nine enemies.
; - Consider having Armsmaster dots for that character.
; - Gracefully fails if your first character clears.
; - Gracefully fails if your first character doesn't clear and your second character runs out of mana.
; - Note that this lays the foundation for any sort of automation for any application, and is not limited to Disgaea 1.
; - Further in are hard-coded delays using the "Sleep" command which you can customize if your system runs the Disgaea 1 slower than intended.



; User-configuration:
miliseconds_holding_a_key_down := 85
delay_between_keystrokes := 75
grind_ability_activate() {
  ; - Choose only one ability.
  key( "e" )  ; Go to the base panel or first unit
  key( "l" )  ; Return unit to base
  key( "k" )  ; Enter base panel
  key( "k" )  ; Select first unit
  move_in_front()
  key( "k" )  ; That unit's menu

  ;staff_fire()
  ;staff_mega_fire()
  ;staff_giga_fire()
  ;staff_omega_fire()
  ;staff_tera_fire()

  ;staff_wind()
  ;staff_mega_wind()
  ;staff_giga_wind()
  ;staff_omega_wind()
  ;staff_tera_wind()

  ;staff_ice()
  staff_mega_ice()
  ;staff_giga_ice()
  ;staff_omega_ice()
  ;staff_tera_ice()

  ;staff_star()
  ;staff_mega_star()
  ;staff_giga_star()
  ;staff_omega_star()
  ;staff_tera_star()

  one_spell_select()
  ;most_spell_select()
  
  target_from_front_to_middle()
}
clear_ability_activate() {
  ; - Choose only one ability.
  ; - This script is designed for a 9x9 ability which is guaranteed to one-shot and clear the stage.
  ; - However, if you are unable to fulfill that requirement, this script is designed to be easily customized, even to the point of letting you control multiple characters.
  ;   - Beware that if you clear the stage yet the script assumes it needs to control additional characters, you will have a mess on your hands.  Try having multiple characters attack different sections of the group, and follow it up with a 9x9.  This was how I did my original grinding for little characters.

  key( "e" )  ; Go to the base panel or first unit
  key( "l" )  ; Return unit to base
  key( "k" )  ; Enter base panel
  key( "k" )  ; Select first unit

  ;staff_fire()
  ;staff_mega_fire()
  ;staff_giga_fire()
  ;staff_omega_fire()
  ;staff_tera_fire()

  ;staff_wind()
  ;staff_mega_wind()
  ;staff_giga_wind()
  ;staff_omega_wind()
  ;staff_tera_wind()

  ;staff_ice()
  ;staff_mega_ice()
  ;staff_giga_ice()
  ;staff_omega_ice()
  ;staff_tera_ice()

  ;staff_star()
  ;staff_mega_star()
  ;staff_giga_star()
  ;staff_omega_star()
  staff_tera_star()

  ;one_spell_select()
  most_spell_select()
  
  target_from_base_to_middle()

  ; N/A for now
  ;clear_sword_winged_slayer()
}
executable := "ahk_exe dis1_st.exe"
; Maybe this would change under some circumstances, perhaps with a future update to AutoHotKey?
; If needed, use the "Window Spy" command via right-clicking your AutoHotKey tray icon to learn the details of an AutoHotKey dialog.
autohotkey_window := "ahk_class #32770"



; -----------------------------------------------------------------------



; Lua-style empty variable
_ := ''



; --------------
;      Fire
; --------------
staff_fire() {
  spell_select()
  key( "k" )
}
staff_mega_fire() {
  spell_select()
  key( "s" )
  key( "k" )
}
staff_giga_fire() {
  spell_select()
  key( "s", 2 )
  key( "k" )
}
staff_omega_fire() {
  spell_select()
  key( "s", 3 )
  key( "k" )
}
staff_tera_fire() {
  spell_select()
  key( "s", 4 )
  key( "k" )
}
; --------------
;      Wind
; --------------
staff_wind() {
  spell_select()
  key( "e" )
  key( "w", 3 )
  key( "k" )
}
staff_mega_wind() {
  spell_select()
  key( "e" )
  key( "w", 2 )
  key( "k" )
}
staff_giga_wind() {
  spell_select()
  key( "e" )
  key( "w" )
  key( "k" )
}
staff_omega_wind() {
  spell_select()
  key( "e" )
  key( "k" )
}
staff_tera_wind() {
  spell_select()
  key( "e" )
  key( "s" )
  key( "k" )
}
; --------------
;      Ice
; --------------
staff_ice() {
  spell_select()
  key( "e" )
  key( "s", 2 )
  key( "k" )
}
staff_mega_ice() {
  spell_select()
  key( "e" )
  key( "s", 3 )
  key( "k" )
}
staff_giga_ice() {
  spell_select()
  key( "e" )
  key( "s", 4 )
  key( "k" )
}
staff_omega_ice() {
  spell_select()
  key( "e", 2 )
  key( "w", 3 )
  key( "k" )
}
staff_tera_ice() {
  spell_select()
  key( "e", 2 )
  key( "w", 2 )
  key( "k" )
}
; --------------
;      Star
; --------------
staff_star() {
  spell_select()
  key( "e", 2 )
  key( "w" )
  key( "k" )
}
staff_mega_star() {
  spell_select()
  key( "e", 2 )
  key( "k" )
}
staff_giga_star() {
  spell_select()
  key( "e", 2 )
  key( "s" )
  key( "k" )
}
staff_omega_star() {
  spell_select()
  key( "e", 2 )
  key( "s", 2 )
  key( "k" )
}
staff_tera_star() {
  spell_select()
  key( "e", 2 )
  key( "s", 3 )
  key( "k" )
  ; This is the fastest method for a regular unit because it goes from the bottom.
  ; However, named units have other abilities at the bottom, interfering with this.
  ;key( "w" ), key( "q" ), key( "w" ), key( "k" )
}



; -------------------
;    Script begins   
; -------------------
; Not generally user-serviceable



; Okay maybe this one is somewhat user-serviceable if you know what you're doing.
$F1:: {
  focus_application()
  key( "k" )  ; Enter the area
  Sleep 3500  ; Wait to enter the area
  grind_ability_activate()
  clear_ability_activate()
  key( "i" )  ; Menu
  key( "k" )  ; Execute
  Sleep 1400  ; Wait for one spell animation to cast
  Sleep 1400  ; Wait for the second spell animation to cast
  ; It is assumed that the stage is noe cleared
  Sleep 2200  ; Wait for the stage end animation to begin and the reward counter to begin
  key( "k" )  ; Stop the reward counter
  key( "k" )  ; Exit reward screen
  Sleep 500   ; Return to the area select screen
}



key( key, times := 1 ) {
  Loop times {
    ; The theory was to ensure that the application is focused at every keystroke.  In practice, it does not work.
    ;focus_application()
    kill_script_if_executable_not_focused()
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



target_from_front_to_middle() {
  key( "a", 2 )  ; Target the enemy in the middle of the nine
  key( "k" )     ; Confirm
}
target_from_base_to_middle() {
  key( "w" )
  key( "a", 4 )  ; Target the middle of the group of 9 (the whole group)
  key( "k" )     ; Confirm
}
one_spell_select() {
  key( "k" )     ; Select the single target spell
}
most_spell_select() {  ; Select the biggest spell size possible
  key( "d", 2 )  ; Select the biggest spell possible
  key( "k" )     ; Select the single target spell
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



clear_sword_winged_slayer() {
  move_in_front()
  key( "k" )     ; That unit's menu
  key( "s" )
  key( "s" )
  key( "k" )     ; Special menu
  key( "s", 3 )  ; Sword > Winged Slayer
  key( "k" )
  key( "a" )     ; Target the group of 9
}



focus_application() {
  if !WinActive(   executable ) {
    WinActivate    executable
    ; Delay the script for up to 2 seconds to wait for the system to switch to the executable's window (i.e. an alt-tab).
    WinWaitActive  executable, _ , 2
  }
  if !WinActive(   executable ) {
    MsgBox "Failed to focus the application:  " . executable . "`nreloading the script."
    Reload
  }
}



kill_script_if_executable_not_focused() {
  if !WinExist( executable ) {
    MsgBox "Executable not found:  " . executable . "`nkilling the script."
    ExitApp
  }
}



; Clear any MsgBox or error dialogs on startup.
; This lets you make mistakes with your on-the-fly script edits.  Just correct your mistakes and save again, and this script will automatically clear the explosion of errors for you.
ClearDialogs() {
  while WinExist( autohotkey_window ) {
    WinClose      autohotkey_window
    Sleep 100  ; Pause to allow closure
  }
}
ClearDialogs()



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
