extends Node2D

var TYPE        = "PLAYER"
var DAMAGE      = 0.5
var SWORD_OWNER = null
var DIRECTION   = null

func _ready():
    SWORD_OWNER.state = "swing"
    SWORD_OWNER.item_maxes["SWORD"]["NUM"] += 1
    $anim.connect("animation_finished", self, "destroy")
    $anim.play(DIRECTION)
    
func destroy(animation):
    SWORD_OWNER.state       = "swing_cool"
    SWORD_OWNER.item_maxes["SWORD"]["NUM"] -= 1
    queue_free()
