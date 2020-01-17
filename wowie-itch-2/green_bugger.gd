extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var spawner = load("res://green_spawner.tscn")

var start_in = 0.50
var start_timer = 0
func _physics_process(delta):
    start_timer += delta
    if start_timer > start_in:
        var heading  = position.direction_to(get_node("../ladybug").position) 
        var velocity = heading * delta * (randi()%200 + 10)
        var collision_info = move_and_collide(velocity)
        if collision_info:
            if collision_info.collider.name == "ladybug":
                var green_spawner = spawner.instance()
                green_spawner.position = collision_info.position
                get_parent().add_child(green_spawner)
                queue_free()
