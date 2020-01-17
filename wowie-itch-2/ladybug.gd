extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MOVE_SPEED    = 175

var SMOOTH_MOTION = true
var MOUSE_LOOK    = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _physics_process(delta):
    var player_delta = Vector2(0,0)
    if SMOOTH_MOTION:
        if Input.is_action_pressed("ui_up"):
            player_delta.y -= MOVE_SPEED * delta
        if Input.is_action_pressed("ui_down"):
            player_delta.y += MOVE_SPEED * delta
        if Input.is_action_pressed("ui_left"):
            player_delta.x -= MOVE_SPEED * delta
        if Input.is_action_pressed("ui_right"):        
            player_delta.x += MOVE_SPEED * delta
    else:
        if Input.is_action_just_pressed("ui_up"):
            player_delta.y -= 29
        if Input.is_action_just_pressed("ui_down"):
            player_delta.y += 29
        if Input.is_action_just_pressed("ui_left"):
            player_delta.x -= 29
        if Input.is_action_just_pressed("ui_right"):        
            player_delta.x += 29       
    if MOUSE_LOOK:
        var mouse_pos = get_viewport().get_mouse_position()
        mouse_pos.x -= 128
        mouse_pos.y -= 120
        rotation = mouse_pos.angle() + deg2rad(90)        
    else:
        if player_delta != Vector2.ZERO:
            rotation = player_delta.angle() + deg2rad(90)
    
    move_and_collide(player_delta)
