#extends entity
#extends "res://engine/entity.gd"
extends KinematicBody2D

# warning-ignore:unused_class_variable
var DAMAGE = .25
var SPEED  = 40
# warning-ignore:unused_class_variable
var TYPE = "STALFAUX"

var movetimer_length = 15
var movetimer = 0
var knockdir = DIR.CENTER

var MAXHEALTH = 1
var movedir = DIR.CENTER
var hitstun = 0
var texture_default = preload("res://enemies/stalfaux.png")
var texture_hurt    = preload("res://enemies/stalfaux_hurt.png")
var health = MAXHEALTH

var item_maxes = {
  "SWORD": { "MAX": 2, "NUM": 0 }
}



func sword_area_entered(msg):
    if msg.sword.OWNER != self and msg.sword.OWNER.TYPE != TYPE and msg.area == $hitbox:
        damage(msg.sword.DAMAGE, msg.sword)
        
var sword_area_entered_ref = funcref(self, "sword_area_entered")

func _ready():
    set_collision_mask_bit(1,1)
    #set_physics_process(false)    
    $anim.play("default")
    movedir = DIR.rand()
    ROUTER.sub('sword_area_entered', sword_area_entered_ref)

func my_sword_is_gone():
    item_maxes["SWORD"]["NUM"] -= 1

func _physics_process(delta):
    movement_loop(delta)
    
    if movetimer > 0:
        movetimer -= 1
    if movetimer == 0 || is_on_wall():
        movedir = DIR.rand()
        movetimer = movetimer_length
        if item_maxes["SWORD"]["NUM"] < item_maxes["SWORD"]["MAX"]:
            item_maxes["SWORD"]["NUM"] += 1
            var sword = ITEMS.create_sword(self, DIR.rand_name().to_lower())
            sword.connect("sword_gone", self, "my_sword_is_gone")
            add_child(sword)
        
func movement_loop(_delta):
    var motion
    if hitstun > 0:
        hitstun -= 1
        $Sprite.texture = texture_hurt
        motion = knockdir.normalized() * 125 
    else:
        $Sprite.texture = texture_default
        motion = movedir.normalized() * SPEED

# warning-ignore:return_value_discarded
    move_and_slide(motion, DIR.CENTER)

func damage(amount, source):
    if source.OWNER.TYPE == "ENEMY":
        return
    
    health -= amount
    knockdir = global_transform.origin - source.global_transform.origin
    hitstun = 10
    $Sprite.texture = texture_hurt
    if health <= 0:
        remove_me()

func instance_scene(scene):
    var new_scene = scene.instance()
    new_scene.global_position = global_position
    get_parent().add_child(new_scene)
    
func remove_me():
    ROUTER.unsub("sword_area_entered", sword_area_entered_ref)
    var drop = randi() % 3
    if drop == 0:
        instance_scene(preload("res://pickups/heart.tscn"))
    
    instance_scene(preload("res://enemies/enemy_death.tscn"))         
    queue_free()
