extends entity
#extends "res://engine/entity.gd"

var DAMAGE = 1

var movetimer_length = 15
var movetimer = 0

func _ready():
    SPEED = 40
    DAMAGE = .25
    $anim.play("default")
    movedir = DIR.rand()

func _physics_process(delta):
    movement_loop()
    damage_loop()
    
    if movetimer > 0:
        movetimer -= 1
    if movetimer == 0 || is_on_wall():
        movedir = DIR.rand()
        movetimer = movetimer_length
