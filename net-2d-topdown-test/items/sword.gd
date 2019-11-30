extends Node2D

var TYPE        = "SWORD"
var DAMAGE      = 0.5
var SWORD_OWNER = null
var DIRECTION   = null

func _ready():
    SWORD_OWNER.state = "swing"
    SWORD_OWNER.item_maxes["SWORD"]["NUM"] += 1
    $anim.connect("animation_finished", self, "destroy")
    $anim.play(DIRECTION)
    
    $area.connect("area_entered", self, "area_entered")
    
func area_entered(area):
    if area.get_parent() != SWORD_OWNER and area.get_parent().has_method("damage"):
        area.get_parent().damage(DAMAGE, self)
    
func destroy(animation):
    SWORD_OWNER.state       = "swing_cool"
    SWORD_OWNER.item_maxes["SWORD"]["NUM"] -= 1
    queue_free()
