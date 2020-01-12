extends KinematicBody2D

var leaves = preload("res://world_things/leaves.tscn")

var chopped = false
var being_chopped = false
var health  = 3
var can_be_chopped = true
var chop_done = false

var chop_interval = 0.1
var chop_timer = chop_interval
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func sword_area_entered(msg):
    if can_be_chopped == false: return
    
    if msg.area == $hitbox:
        if health > 0:
            being_chopped = true
            $tree.modulate = Color(1,0,0)
        
var sword_area_entered_ref = funcref(self, "sword_area_entered")
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    ROUTER.sub('sword_area_entered', sword_area_entered_ref)


func _process(delta):
    if can_be_chopped == false: return
    
    if being_chopped:
        chop_timer -= delta
    if chop_timer < 0:
        chop_done     = true
        being_chopped = false
        health      -= 1
    if chop_done:
        chop_done = false
        chop_timer = chop_interval
        $tree.modulate = Color(1,1,1)
        print('chop done')
    if health == 0:
        var offsets = [
            Vector2(-10,  -30),
            Vector2(0,    -30),
            Vector2(10,   -30),
                
            Vector2(-20,  -20),
            Vector2(-10,  -20),
            Vector2(0,    -20),
            Vector2(10,   -20),
            Vector2(20,   -20),
            
            Vector2(-20,  -10),
            Vector2(-10,  -10),
            Vector2(0,    -10),
            Vector2(10,   -10),
            Vector2(20,   -10),      
            
            Vector2(-20,  0),
            Vector2(-10,  0),
            Vector2(0,    0),
            Vector2(10,   0),
            Vector2(20,   0),
            
            Vector2(-10,  10),
            Vector2(0,    10),
            Vector2(10,   10),
        ]
        for offset in offsets:
            var leaf = leaves.instance()
            leaf.translate(offset)
            add_child(leaf)
        
        $tree.queue_free()
        
        $stump.visible = true
        can_be_chopped = false
        
