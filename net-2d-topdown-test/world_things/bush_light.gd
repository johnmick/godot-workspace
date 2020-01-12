extends KinematicBody2D

var chopped = false
var being_chopped = false
var health  = 3
var can_be_chopped = true
var chop_done = false

var chop_interval = 0.1
var chop_timer = chop_interval

var leaves = preload("res://world_things/leaves.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func sword_area_entered(msg):
    if can_be_chopped == false: return
    
    if msg.area == $hitbox:
        if health > 0:
            being_chopped = true
            $alive.modulate = Color(1,0,0)
        
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
        $alive.modulate = Color(1,1,1)
        print('chop done')
    if health == 0:
        $alive.queue_free()
        $dead.visible = true
        can_be_chopped = false
        var offsets = [
            Vector2(-25, -26),
            Vector2(-20, -26),
            Vector2(-15, -26),
            Vector2( -5, -26),
            
            Vector2(-25,  -20),
            Vector2(-20,  -20),
            Vector2(-13,  -20),
            Vector2( -5,  -20),      
            
            Vector2(-25,  -18),
            Vector2(-20,  -18),
            Vector2(-13,  -18),
            Vector2( -5,  -18), 
            
            Vector2(-25,  -14),
            Vector2(-20,  -14),
            Vector2(-13,  -14),
            Vector2( -5,  -14),            
        ]
        for offset in offsets:
            var leaf = leaves.instance()
            leaf.translate(offset)
            add_child(leaf)        
