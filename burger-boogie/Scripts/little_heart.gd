extends Node2D

func _ready():
    if $Timer.connect("timeout", self, "remove_heart") != 0:
        print("Error connecting timer:timeout to little_heart:remove_heart")
    $AnimationPlayer.play("float_off")
    
    
func remove_heart():
    self.queue_free()