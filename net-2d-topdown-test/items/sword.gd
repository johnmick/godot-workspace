extends Node2D

# warning-ignore:unused_class_variable
var DAMAGE    = 0.5
# warning-ignore:unused_class_variable
var OWNER     = null
var DIRECTION = null

signal sword_gone

func _ready():
    UTIL.checked_connect($anim, "animation_finished", self, "destroy")
    UTIL.checked_connect($area, "area_entered", self, "area_entered")
    $anim.play(DIRECTION)
    
func area_entered(area):
    ROUTER.pub('sword_area_entered', {
        "sword": self,
        "area":  area    
    })
    
func destroy(_animation):
    emit_signal("sword_gone")
    queue_free()
