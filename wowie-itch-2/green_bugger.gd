extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


var start_in = 5
var start_timer = 0
func _process(delta):
    start_timer += delta
    if start_timer > start_in:
        var heading = position.direction_to(get_node("../ladybug").position)
    
        move_and_slide(heading * 5500 * delta)
    
