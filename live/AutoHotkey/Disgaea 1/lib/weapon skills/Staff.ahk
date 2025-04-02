; Select the single target spell
one_spell_select() {
  key( "k" )
}



; Large square with a hole in the middle
eight_spell_select() {
  key( "d" )
  key( "s", 3 )
  key( "k" )
}



; Select the biggest spell size possible
most_spell_select() {
  key( "d", 2 )
  key( "k" )
}



; --------------
;      Fire
; --------------
staff_Fire() {
  special_select()
  key( "k" )
}
staff_Mega_Fire() {
  special_select()
  key( "s" )
  key( "k" )
}
staff_Giga_Fire() {
  special_select()
  key( "s", 2 )
  key( "k" )
}
staff_Omega_Fire() {
  special_select()
  key( "s", 3 )
  key( "k" )
}
staff_Tera_Fire() {
  special_select()
  key( "s", 4 )
  key( "k" )
}
; --------------
;      Wind
; --------------
staff_Wind() {
  special_select()
  key( "e" )
  key( "w", 3 )
  key( "k" )
}
staff_Mega_Wind() {
  special_select()
  key( "e" )
  key( "w", 2 )
  key( "k" )
}
staff_Giga_Wind() {
  special_select()
  key( "e" )
  key( "w" )
  key( "k" )
}
staff_Omega_Wind() {
  special_select()
  key( "e" )
  key( "k" )
}
staff_Tera_Wind() {
  special_select()
  key( "e" )
  key( "s" )
  key( "k" )
}
; --------------
;      Ice
; --------------
staff_Ice() {
  special_select()
  key( "e" )
  key( "s", 2 )
  key( "k" )
}
staff_Mega_Ice() {
  special_select()
  key( "e" )
  key( "s", 3 )
  key( "k" )
}
staff_Giga_Ice() {
  special_select()
  key( "e" )
  key( "s", 4 )
  key( "k" )
}
staff_Omega_Ice() {
  special_select()
  key( "e", 2 )
  key( "w", 3 )
  key( "k" )
}
staff_Tera_Ice() {
  special_select()
  key( "e", 2 )
  key( "w", 2 )
  key( "k" )
}
; --------------
;      Star
; --------------
staff_Star() {
  special_select()
  key( "e", 2 )
  key( "w" )
  key( "k" )
}
staff_Mega_Star() {
  special_select()
  key( "e", 2 )
  key( "k" )
}
staff_Giga_Star() {
  special_select()
  key( "e", 2 )
  key( "s" )
  key( "k" )
}
staff_Omega_Star() {
  special_select()
  key( "e", 2 )
  key( "s", 2 )
  key( "k" )
}
staff_Tera_Star() {
  special_select()
  key( "e", 2 )
  key( "s", 3 )
  key( "k" )
  ; This is the fastest method for a regular unit because it goes from the bottom.
  ; However, named units have other abilities at the bottom, interfering with this.
  ;key( "w" ), key( "q" ), key( "w" ), key( "k" )
}
; --------------
;      Heal
; --------------
staff_Heal() {
  special_select()
  key( "e", 3 )
  key( "w", 4 )
  key( "k" )
}
staff_Mega_Heal() {
  special_select()
  key( "e", 3 )
  key( "w", 3 )
  key( "k" )
}
staff_Giga_Heal() {
  special_select()
  key( "e", 3 )
  key( "w", 2 )
  key( "k" )
}
staff_Omega_Heal() {
  special_select()
  key( "e", 3 )
  key( "w" )
  key( "k" )
}
; Note that there is no "Tera Heal"
; --------------
;      Misc
; --------------
staff_Espoir() {
  special_select()
  key( "e", 3 )
  key( "k" )
}
staff_Braveheart() {
  special_select()
  key( "e", 3 )
  key( "s" )
  key( "k" )
}
staff_Shield() {
  special_select()
  key( "e", 3 )
  key( "s", 2 )
  key( "k" )
}
staff_Magic Boost() {
  special_select()
  key( "e", 3 )
  key( "s", 3 )
  key( "k" )
}
staff_Magic Wall() {
  special_select()
  key( "e", 3 )
  key( "s", 4 )
  key( "k" )
}
