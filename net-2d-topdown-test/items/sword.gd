extends Node2D

var TYPE = null
var DAMAGE = 0.5

var maxamount = 1

func _ready():
    TYPE = get_parent().TYPE
    $anim.connect("animation_finished", self, "destroy")
    $anim.play(str("swing",get_parent().spritedir))
    if get_parent().has_method("state_swing"):
        get_parent().state = "swing"
    
func destroy(animation):
    if get_parent().has_method("state_swing"):
        get_parent().state = "swing_cool"
    queue_free()
