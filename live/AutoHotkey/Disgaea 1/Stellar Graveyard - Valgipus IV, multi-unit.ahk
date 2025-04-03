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

  ;staff_Fire()
  ;staff_Mega_Fire()
  ;staff_Giga_Fire()
  ;staff_Omega_Fire()
  ;staff_Tera_Fire()

  ;staff_Wind()
  ;staff_Mega_Wind()
  ;staff_Giga_Wind()
  ;staff_Omega_Wind()
  ;staff_Tera_Wind()

  ;staff_Ice()
  ;staff_Mega_Ice()
  ;staff_Giga_Ice()
  ;staff_Omega_Ice()
  ;staff_Tera_Ice()

  ;staff_Star()
  ;staff_Mega_Star()
  ;staff_Giga_Star()
  ;staff_Omega_Star()
  staff_Tera_Star()

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

  ;staff_Fire()
  ;staff_Mega_Fire()
  ;staff_Giga_Fire()
  ;staff_Omega_Fire()
  ;staff_Tera_Fire()

  ;staff_Wind()
  ;staff_Mega_Wind()
  ;staff_Giga_Wind()
  ;staff_Omega_Wind()
  ;staff_Tera_Wind()

  ;staff_Ice()
  ;staff_Mega_Ice()
  ;staff_Giga_Ice()
  ;staff_Omega_Ice()
  ;staff_Tera_Ice()

  ;staff_Star()
  ;staff_Mega_Star()
  ;staff_Giga_Star()
  ;staff_Omega_Star()
  staff_Tera_Star()

  ;one_spell_select()
  eight_spell_select()
  ;most_spell_select()
  
  target_from_base_to_middle()

  ; N/A for now
  ;sword_Winged_Slayer()
}



self_ability_activate() {
  ; This isn't reliable.  Just have your unit somewhere safe, and keep the cursor overtop of it.
  ;key( "e" )  ; Go to the first unit
  key( "k" )  ; Select that unit
  ;staff_Heal()
  ;staff_Mega_Heal()
  ;staff_Giga_Heal()
  staff_Omega_Heal()
  ;staff_Espoir()
  ;staff_Braveheart()
  ;staff_Shield()
  ;staff_Magic_Boost()
  ;staff_Magic_Wall()
  one_spell_select()
  target_self()
}


loop_number_of_times := 10
self_ability := true

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
    ; Comment-out the following two if using self_ability_activate
  ;  key( "k" )  ; Enter the area
  ;  Sleep 3500  ; Wait to enter the area
    ; Go to the training area, have only one unit out, move your unit to the far bottom-left corner.
    ; Your cursor must be on the unit.  If it is not, press e.
    self_ability_activate()
  ;  grind_ability_activate()
  ;  clear_ability_activate()
    key( "i" )  ; Menu
    key( "s" )  ; End Turn
    key( "k" )  ; Execute
    focus_application()
    Sleep 1400  ; Wait for one spell animation to cast
    focus_application()
    if ( self_ability ) {
      Sleep 4000  ; Wait for the round end animation
    }
  }
  if ( !self_ability ) {
    Reload  ; Un-comment if using self_ability_activate
    Sleep 1400  ; Wait for the second spell animation to cast
    ; It is assumed that the stage is now cleared
    Sleep 2200  ; Wait for the stage end animation to begin and the reward counter to begin
    key( "k" )  ; Stop the reward counter
    key( "k" )  ; Exit reward screen
    Sleep 500   ; Return to the area select screen
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
