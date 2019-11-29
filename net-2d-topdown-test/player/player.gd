extends entity
#extends "res://engine/entity.gd"

var state = "default"

var keys = 0

func _init():
    TYPE = "PLAYER"
    MAXHEALTH = 16
    SPEED = 70
    health = MAXHEALTH
    

func state_default():
    controls_loop()
    movement_loop()
    spritedir_loop()
    damage_loop()
    
    if movedir == DIR.CENTER:
        anim_switch("idle")
    elif is_on_wall():
        if spritedir == "left" and test_move(transform, DIR.LEFT):
            anim_switch("push")
        if spritedir == "right" and test_move(transform, DIR.RIGHT):
            anim_switch("push")
        if spritedir == "up" and test_move(transform, DIR.UP):
            anim_switch("push")
        if spritedir == "down" and test_move(transform, DIR.DOWN):
            anim_switch("push")                            
    else:
        anim_switch("walk")
        
    if Input.is_action_just_pressed("a"):
        use_item(preload("res://items/sword.tscn"))
            
func state_swing():
    anim_switch("idle")
    movement_loop()
    damage_loop()
    movedir = DIR.CENTER

func _physics_process(delta):
    match state:
        "default":
            state_default()
        "swing":
            state_swing()
            
    keys = min(keys, 9)

func controls_loop():
    var LEFT  = Input.is_action_pressed("ui_left")
    var RIGHT = Input.is_action_pressed("ui_right")
    var UP    = Input.is_action_pressed("ui_up")
    var DOWN  = Input.is_action_pressed("ui_down")
    
    movedir.x = -int(LEFT) + int(RIGHT)
    movedir.y = -int(UP) + int(DOWN)
