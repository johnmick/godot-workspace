extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var busted_texture = preload("res://busted_ball.png")
onready var ant_scene = preload("res://ant.tscn")
onready var ant_home_positions  = [
    get_node("../../ant_home1").position,
    get_node("../../ant_home2").position,
    get_node("../../ant_home3").position,
    get_node("../../ant_home4").position,
    get_node("../../ant_home5").position,
    get_node("../../ant_home6").position,
    get_node("../../ant_home7").position,
    get_node("../../ant_home8").position,
    get_node("../../ant_home9").position,
]
onready var ant_parent = get_node("/root/breakout")


# Called when the node enters the scene tree for the first time.
func _ready():
    $AudioStreamPlayer2D.pitch_scale = randf() + .05
    pass # Replace with function body.


var gonna_leave = false
var leave_time  = .75
var leave_timer = 0
func _process(delta):
    if gonna_leave:
        leave_timer += delta
    if leave_timer > leave_time:
        queue_free()
        pass
    
func gonna_leave():
    gonna_leave = true
    get_node("Sprite").texture = busted_texture
    

func _physics_process(delta):
    for body in get_colliding_bodies():
        if "wall" in body.name:
            #body.gonna_leave()
            pass
        if "ball_capture" == body.name:
            var ant = ant_scene.instance()
            ant.position = ant_home_positions[randi() % len(ant_home_positions)]
            ant.linear_velocity = Vector2((randf() - .5) * 50, -randf() * 200)
            ant_parent.add_child(ant)
            queue_free()
        if "paddle" == body.name:
            gonna_leave()
        
        if "ant" in body.name:
            gonna_leave()
