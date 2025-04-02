; THIS IS A SCRIPT VARIATION - The first party member casts one spell, the stage is cleared by the next party member.
; TODO - more universality to have just the one unit, as before.
; TODO - test with other areas, to make sure things are universal there too (likely just movement.ahk)



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
; - While this uses the F1 hotkey, that can be configured below.



#Requires AutoHotkey v2
#SingleInstance Force
#UseHook
SendMode "Input"
;#Warn  ; Enable warnings to assist with detecting common errors.



; User-configuration:
milliseconds_holding_a_key_down := 85
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
  ;staff_mega_ice()
  ;staff_giga_ice()
  ;staff_omega_ice()
  staff_tera_ice()

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
  ;   - Beware that if you clear the stage yet this script assumes it needs to control additional characters, you will have a mess on your hands.  Try having multiple characters attack different sections of the group, and follow it up with a 9x9.  This was how I did my original grinding for little characters.

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
  eight_spell_select()
  ;most_spell_select()
  
  target_from_base_to_middle()

  ; N/A for now
  ;sword_winged_slayer()
}



; Okay maybe this one is somewhat user-serviceable if you know what you're doing.
$F1:: {
  if !WinExist( executable ) {
    MsgBox "Executable not found:  " . executable
    Reload
  }
  ; I don't know why this doesn't work:
  ;ClearDialogs()
  focus_application()
  key( "k" )  ; Enter the area
  Sleep 3500  ; Wait to enter the area
  grind_ability_activate()
  clear_ability_activate()
  key( "i" )  ; Menu
  key( "k" )  ; Execute
  Sleep 1400  ; Wait for one spell animation to cast
  Sleep 1400  ; Wait for the second spell animation to cast
  ; It is assumed that the stage is now cleared
  Sleep 2200  ; Wait for the stage end animation to begin and the reward counter to begin
  key( "k" )  ; Stop the reward counter
  key( "k" )  ; Exit reward screen
  Sleep 500   ; Return to the area select screen
}



executable := "ahk_exe dis1_st.exe"
; Maybe this would change under some circumstances, perhaps with a future update to AutoHotKey?
; If needed, use the "Window Spy" command via right-clicking your AutoHotKey tray icon to learn the details of an AutoHotKey dialog.
autohotkey_window := "ahk_class #32770"



; -------------------
;    Script begins
; -------------------



; Auto-reload this script (and its dependencies) when this file is edited.
; I'm not going to bother determining if any libraries get modified.
script_timestamp_initial   := FileGetTime( A_ScriptFullPath, "M" )
SetTimer check_for_timestamp_change, 2000
check_for_timestamp_change() {
  script_timestamp_current := FileGetTime( A_ScriptFullPath, "M" )
  if ( script_timestamp_current != script_timestamp_initial ) {
    Reload
    Sleep 2000
    MsgBox "Reload failed!"
  }
}



; These are down here because variables are set above.
; Their order is unimportant because of the structure of this scripting.
#Include "lib\general.ahk"
#Include "lib\staff.ahk"
#Include "lib\sword.ahk"
; The #Include command does not support variables; this must be hard-coded for your area of interest.
#Include "lib\Stellar Graveyard\Valgipus IV\movement.ahk"
