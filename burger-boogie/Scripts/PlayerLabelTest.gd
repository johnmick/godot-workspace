extends RichTextLabel

func _on_Player_player_position_change(state, hold):
    text = str(state) + " " + str(hold)
