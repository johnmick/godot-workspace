extends Node2D

onready var ball_scene = preload("res://wall.tscn")


export var spawn_interval    = 1.0
export var linear_velocity_x = 50
export var linear_velocity_y = -125
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
var spawn_timer =  0
func _process(delta):
    spawn_timer += delta
    if spawn_timer > spawn_interval:
        make_ball()
        spawn_timer = 0


func make_ball():
    var the_ball = ball_scene.instance()
    the_ball.linear_velocity  = Vector2(linear_velocity_x, linear_velocity_y)
    #the_ball.angular_velocity = (randf() - .5) * 8 * PI
    #the_ball.rotation_degrees = rand_range(0, 360)
    add_child(the_ball)
