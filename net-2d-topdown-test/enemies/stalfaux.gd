#extends entity
#extends "res://engine/entity.gd"
extends KinematicBody2D

var DAMAGE = .25
var SPEED  = 40
var TYPE = "ENEMY"

var state = "default"

var movetimer_length = 15
var movetimer = 0
var knockdir = DIR.CENTER

var MAXHEALTH = 1
var movedir = DIR.CENTER
var hitstun = 0
var texture_default = preload("res://enemies/stalfaux.png")
var texture_hurt    = preload("res://enemies/stalfaux_hurt.png")
var health = MAXHEALTH

var active_item = "SWORD"
var item_maxes = {
  "SWORD": { "MAX": 1, "NUM": 0 }
}

func _ready():
    set_collision_mask_bit(1,1)
    set_physics_process(false)    
    $anim.play("default")
    movedir = DIR.rand()

func _physics_process(delta):
    movement_loop()
    #damage_loop()
    
    if movetimer > 0:
        movetimer -= 1
    if movetimer == 0 || is_on_wall():
        movedir = DIR.rand()
        movetimer = movetimer_length
        if item_maxes["SWORD"]["NUM"] < item_maxes["SWORD"]["MAX"]:
            add_child( ITEMS.create_sword(self, DIR.rand_name().to_lower()) )
        
func movement_loop():
    var motion
    if hitstun > 0:
        hitstun -= 1
        $Sprite.texture = texture_hurt
        motion = knockdir.normalized() * 125 
    else:
        $Sprite.texture = texture_default
        motion = movedir.normalized() * SPEED

    move_and_slide(motion, DIR.CENTER)

func damage(amount, source):
    if source.SWORD_OWNER.TYPE == "ENEMY":
        return
    
    health -= amount
    knockdir = global_transform.origin - source.global_transform.origin
    hitstun = 10
    $Sprite.texture = texture_hurt
    if health <= 0:
      var drop = randi() % 3
      if drop == 0:
        instance_scene(preload("res://pickups/heart.tscn"))
      instance_scene(preload("res://enemies/enemy_death.tscn"))                
      queue_free()

func instance_scene(scene):
    var new_scene = scene.instance()
    new_scene.global_position = global_position
    get_parent().add_child(new_scene)
