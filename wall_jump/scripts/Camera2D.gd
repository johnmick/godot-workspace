extends Camera2D

onready var player = get_node("../player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var pause_timer = 0
var pause_time  = .025
func _process(delta):
    position = player.position
    
    if pause_timer > pause_time:
        get_tree().paused = false
    else:
        pause_timer += delta

var need_to_unpause = false
func flash_pause():
    get_tree().paused = true
    pause_timer = 0
