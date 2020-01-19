extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var ball_age = 0
var ball_lifespan = .75

# Called when the node enters the scene tree for the first time.
func _ready():
    modulate = Color(randf(), randf(), randf(), 1)
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    ball_age += delta
    if ball_age > ball_lifespan:
        queue_free()
        
    for body in get_colliding_bodies():
        if "wall" in body.name or "ant" in body.name:
            body.gonna_leave()
