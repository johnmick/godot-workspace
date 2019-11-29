extends KinematicBody2D

var state = "default"
var TYPE  = "PLAYER"
var keys  = 0
var MAXHEALTH = 16
var SPEED = 70
var health = MAXHEALTH

var motion = DIR.CENTER
var movedir = DIR.CENTER
var knockdir = DIR.CENTER
var spritedir = "down"

var active_item = "SWORD"
var item_maxes = {
  "SWORD": { "MAX": 1, "NUM": 0 }
}

var hitstun = 0
onready var texture_default = $Sprite.texture
onready var texture_hurt    = load($Sprite.texture.get_path().replace(".png", "_hurt.png"))

# Godot Procedures ------------------------------------------------------------------------
func _physics_process(delta):
  if Input.is_action_just_pressed("a"):
    if item_maxes[active_item]["NUM"] < item_maxes[active_item]["MAX"]:
      call(str("use_item_",active_item))

  match state:
    "default":
      state_default()
    "swing":
      state_swing()
    "swing_cool":
      state_swing_cool()
  keys = min(keys, 9)
# -----------------------------------------------------------------------------------------

# States ----------------------------------------------------------------------------------
func state_default():
    walking_loop()
    hitstun_loop()
    movement_loop()
    spritedir_loop(movedir)
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
        
var last_look = null
func state_swing():
    anim_switch("idle")
    hitstun_loop()
    movement_loop()
    damage_loop()

    if Input.is_action_just_pressed("ui_left"):
      last_look = DIR.LEFT
    elif Input.is_action_just_pressed("ui_right"):
      last_look = DIR.RIGHT
    elif Input.is_action_just_pressed("ui_up"):
      last_look = DIR.UP
    elif Input.is_action_just_pressed("ui_down"):
      last_look = DIR.DOWN
    movedir = DIR.CENTER

func state_swing_cool():
  spritedir_loop(last_look)
  last_look = null
  state = "default"
# -----------------------------------------------------------------------------------------


# Common Loops ----------------------------------------------------------------------------
func walking_loop():
  movedir.x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
  movedir.y = -int(Input.is_action_pressed("ui_up"))   + int(Input.is_action_pressed("ui_down"))

func hitstun_loop():
  if hitstun == 0:
    motion = movedir.normalized() * SPEED
  else:
    motion = knockdir.normalized() * 125 

func movement_loop():
  move_and_slide(motion, DIR.CENTER)

func spritedir_loop(facedir):
    match facedir:
        DIR.LEFT:
            spritedir = "left"
        DIR.RIGHT:
            spritedir = "right"
        DIR.UP:
            spritedir = "up"
        DIR.DOWN:
            spritedir = "down"    

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
# -----------------------------------------------------------------------------------------




func anim_switch(animation):
    var newanim = str(animation,spritedir)
    if $anim.current_animation != newanim:
        $anim.play(newanim)
        
func use_item_SWORD():
  if item_maxes["SWORD"]["NUM"] < item_maxes["SWORD"]["MAX"]:
    add_child( ITEMS.create_sword(self, spritedir) )

func instance_scene(scene):
    var new_scene = scene.instance()
    new_scene.global_position = global_position
    get_parent().add_child(new_scene)
