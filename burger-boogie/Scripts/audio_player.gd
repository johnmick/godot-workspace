extends Node
    
func new_wave_begin():
    $new_wave_begin.play()
    
func food_mismatch():
    $food_mismatch.play()
    
func food_matched():
    $food_match.play()
    
func menu_select():
    $menu_select.play()
    
func menu_open():
    $menu_select.play()
    
func menu_select_change():
    $menu_select.play()
    
func menu_close():
    $menu_select.play()
    
func monster_spit():
    $monster_spit.play()
    
func monster_start_spit():
    $monster_start_spit.play()
    
func monster_end_spit():
    $monster_end_spit.play()
    
func player_move():
    $player_move.play()    
    
func food_select_change():
    $food_select_change.play()        
    
func game_over():
    $game_over.play() 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
