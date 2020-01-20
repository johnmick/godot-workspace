extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var starting_y = position.y

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    #Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

var mouse_speed = Vector2.ZERO


func _input(event):
    if event is InputEventMouseMotion:
        if abs(event.relative[0]) > 1:
            mouse_speed = Vector2(event.relative[0] * 50, event.relative[1] * 50)

func _integrate_forces(state):
    state.set_linear_velocity(mouse_speed)
    mouse_speed = Vector2.ZERO
    #state.set_angular_velocity(0)


func _physics_process(delta):
    pass
    #transform = Transform2D(0, Vector2(position.x, starting_y))

func _process(delta):
    #position = get_viewport().get_mouse_position()
    pass
