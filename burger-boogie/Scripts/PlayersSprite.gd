extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_Player_player_position_change(state, hold):
    frame    = state
    modulate = Color(1 - hold, 1, 1 - hold)