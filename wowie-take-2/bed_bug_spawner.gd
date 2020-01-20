extends Node2D

onready var ant_scene = preload("res://ant.tscn")

export var velocity_x = 0.0
export var velocity_y = 0.0
export var spawn_interval_min = 2.0
export var spawn_interval_max = 5.0
export var spawn_rotation_min = 0.0
export var spawn_rotation_max = 0.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var original_velocity_x = 0.0
var original_velocity_y = 0.0
var original_spawn_interval_min = 2.0
var original_spawn_interval_max = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
    original_velocity_x = velocity_x
    original_velocity_y = velocity_y
    original_spawn_interval_min = spawn_interval_min
    original_spawn_interval_max = spawn_interval_max


var spawn_interval = rand_range(spawn_interval_min, spawn_interval_max)
var spawn_timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    spawn_timer += delta
    
    if spawn_timer > spawn_interval:
        var ant = ant_scene.instance()
        ant.position = position
        ant.linear_velocity = Vector2(velocity_x, velocity_y)
        ant.rotation_degrees = rand_range(spawn_rotation_min, spawn_rotation_max)
        spawn_timer    = 0
        spawn_interval = rand_range(spawn_interval_min, spawn_interval_max)
        get_parent().add_child(ant)
