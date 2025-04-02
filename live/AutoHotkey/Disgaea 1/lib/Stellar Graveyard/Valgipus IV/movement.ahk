target_from_front_to_middle() {
  key( "a", 2 )  ; Target the enemy in the middle of the nine
  key( "k" )     ; Confirm
}



target_from_base_to_middle() {
  key( "w" )
  key( "a", 4 )  ; Target the middle of the group of 9 (the whole group)
  key( "k" )     ; Confirm
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
