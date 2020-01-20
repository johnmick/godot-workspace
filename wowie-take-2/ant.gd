extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var busted_texture = preload("res://busted_ant.png")


# Called when the node enters the scene tree for the first time.
func _ready():
    $AudioStreamPlayer2D.pitch_scale = randf() + .05
    pass # Replace with function body.


var gonna_leave = false
var leave_time  = 1
var leave_timer = 0

var waking_up_time  = .5
var waking_up_timer = 0
func _process(delta):
    waking_up_timer += delta
    if waking_up_timer < waking_up_time: return
    if gonna_leave:
        leave_timer += delta
    if leave_timer > leave_time:
        queue_free()
    
func gonna_leave():
    gonna_leave = true
    $AudioStreamPlayer2D.play()
    #$Sprite/AnimationPlayer2.play()
    get_node("Sprite").texture = busted_texture
    

func _physics_process(delta):
    if waking_up_timer < waking_up_time: 
        return
    
    if gonna_leave:
        scale = scale * 1.5
        return
    
    for body in get_colliding_bodies():
        if body.get_parent().name == "player":
            if body.get_node("Sprite/AnimationPlayer").is_playing() and body.get_node("Sprite/AnimationPlayer").current_animation_position < .3:
                gonna_leave()
                body.get_parent().score += int(rand_range(1,4))
            else:
                body.get_parent().health -= 1
                body.get_parent().modulate += Color(1.0, -.1, -.1, 0)
        if "ant" in body.name:
            gonna_leave()
        if "wall" in body.name:
            gonna_leave()
            #body.gonna_leave()
            body.get_node("BiteSound").pitch_scale = rand_range(.9, 1.1)
            body.get_node("BiteSound").play()
        if "paddle" == body.name:
            gonna_leave()    
            $AudioStreamPlayer2D.play()
            pass
            
        if "ball_capture" == body.name:
            scale = Vector2(randf() * 15, randf() * 15)
            add_force(Vector2.ZERO, Vector2((randf() - .5) * 2000, (randf() - .5) * 2000))
            #leave_time = randf() * 5 + .5
            leave_time = randf() * 2 + .5
            gonna_leave()
