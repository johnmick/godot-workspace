extends Node

func _ready():
    $anim.play("default")
    UTIL.checked_connect($anim, "animation_finished", self, "destroy")
    
func destroy(_animation):
    queue_free()
