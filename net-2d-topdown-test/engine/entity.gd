class_name entity
extends KinematicBody2D

var MAXHEALTH = 1
var TYPE = "ENEMY"
var SPEED = 0

var movedir = DIR.CENTER
var knockdir = DIR.CENTER
var spritedir = "down"

var hitstun = 0
var texture_default = null
var texture_hurt    = null
var health = MAXHEALTH

func _ready():
    if TYPE == "ENEMY" or TYPE == "toggler":
        set_collision_mask_bit(1,1)
        set_physics_process(false)
    texture_default = $Sprite.texture
    texture_hurt = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))

func movement_loop():
    var motion
    if hitstun == 0:
        motion = movedir.normalized() * SPEED
    else:
        motion = knockdir.normalized() * 125 
    
    move_and_slide(motion, DIR.CENTER)
    
    if NETWORK.configured:
        #NETWORK.socketUDP.put_var(global_transform)
        pass

func spritedir_loop():
    match movedir:
        DIR.LEFT:
            spritedir = "left"
        DIR.RIGHT:
            spritedir = "right"
        DIR.UP:
            spritedir = "up"
        DIR.DOWN:
            spritedir = "down"
            
func anim_switch(animation):
    var newanim = str(animation,spritedir)
    if $anim.current_animation != newanim:
        $anim.play(newanim)
                    
func damage_loop():
    health = min(MAXHEALTH, health)
    
    if hitstun > 0:
        hitstun -= 1
        $Sprite.texture = texture_hurt
    else:
        $Sprite.texture = texture_default
        if TYPE == "ENEMY" and health <= 0:
            var drop = randi() % 3
            if drop == 0:
                instance_scene(preload("res://pickups/heart.tscn"))
            instance_scene(preload("res://enemies/enemy_death.tscn"))                
            queue_free()
        
    for area in $hitbox.get_overlapping_areas():
        var body = area.get_parent()
        
        if area.has_method("toggle"):
            area.toggle()
            
        if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
            health -= body.get("DAMAGE")
            hitstun = 10
            knockdir = global_transform.origin - body.global_transform.origin

func use_item(item):
    var newitem = item.instance()
    newitem.add_to_group(str(item,self))
    add_child(newitem)
    if get_tree().get_nodes_in_group(str(item,self)).size() > newitem.maxamount:
        newitem.queue_free()

func instance_scene(scene):
    var new_scene = scene.instance()
    new_scene.global_position = global_position
    get_parent().add_child(new_scene)
