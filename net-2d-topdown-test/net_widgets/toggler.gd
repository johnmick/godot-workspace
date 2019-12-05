extends StaticBody2D

export (bool) var on = true





func toggle(msg):
    print(msg, ' ', self.name)
    on = msg["on"]
    set_sprite()
    
func set_sprite():
    $Sprite.frame = 0 if on else 1
    $CollisionShape2D.call_deferred("set_disabled", not on)

var toggle_ref = funcref(self, "toggle")    
func _ready():
    set_sprite()
    ROUTER.sub("toggle_switches", toggle_ref)
