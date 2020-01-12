extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2 var b = "text"

var standing = true
var pecking = false
var struck = false

var decide_interval = randi()%4+2
var decide_timer    = decide_interval
var run_speed    = Vector2(randi()%1000+500, 0)
var run_direction = Vector2(1, 0)
var running_left = false
var health = 10

func sword_area_entered(msg):
    #if can_be_chopped == false: return
    
    if msg.area == $hitbox:
        if health > 0:
            struck = true
            standing = true
            pecking = false
            decide_timer = decide_interval
            run_speed *= Vector2.ZERO
                        
        
var sword_area_entered_ref = funcref(self, "sword_area_entered")

# Called when the node enters the scene tree for the first time.
func _ready():
    ROUTER.sub('sword_area_entered', sword_area_entered_ref)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    decide_timer -= delta
    if struck:
        decide_timer -= delta * 2
    if pecking:
        decide_timer -= delta * 3
        
    if decide_timer < 0:
        decide_timer = decide_interval
        struck = false
        standing = not standing
        if standing:
            pecking = randi()%10 > 5
        else:
            if not pecking:
                run_speed = Vector2(randi()%5000+500, 0)
                running_left = not running_left
                if running_left:
                    run_direction = Vector2(-1, 0)
                    $running.flip_h = false
                else:
                    run_direction = Vector2(1, 0)
                    $running.flip_h = true
        
    if struck:
        $running.visible  = false
        $peck.visible = false
        $standing.visible = false        
        $struck.visible = true
    elif pecking:
        $running.visible  = false
        $peck.visible = true
        $standing.visible = false
        $struck.visible = false
    elif standing:
        $running.visible  = false
        $standing.visible = true
        $peck.visible = false
        $struck.visible = false
    else:
        move_and_slide(run_speed * delta * run_direction, Vector2.ZERO)
        $standing.visible = false
        $peck.visible = false
        $running.visible = true
        $struck.visible = false
