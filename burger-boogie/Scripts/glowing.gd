extends Node2D

func _ready():
    if menu.connect("new_game_request", self, "new_game_request") != 0:
        print("Error binding menu:new_game_request to glowing:new_game_request")
    
func new_game_request():
    queue_free()