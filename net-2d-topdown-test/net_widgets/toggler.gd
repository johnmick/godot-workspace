extends StaticBody2D

export (bool) var on = true

func _ready():
    set_sprite()

func toggle():
    on = not on
    set_sprite()
    
func set_sprite():
    $Sprite.frame = 0 if on else 1
    $CollisionShape2D.call_deferred("set_disabled", not on)
