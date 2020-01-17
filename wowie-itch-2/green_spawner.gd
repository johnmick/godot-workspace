extends Node2D


var green_bug = preload("res://green_bugger.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var spawn_rate = 2
var spawn_timer = 0
func _physics_process(delta):
    spawn_timer += delta
    if spawn_timer > spawn_rate:
        var bug = green_bug.instance()
        bug.position = position
        get_parent().add_child(bug)
        spawn_timer = 0 
