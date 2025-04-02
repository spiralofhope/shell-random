spell_select() {
  key( "s" )
  key( "s" )
  key( "k" )  ; Special menu
}



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
