extends StaticBody2D

export (bool) var on_light = true

var starting_speed = 3

func _ready():
    $hitbox.connect("area_entered", self, "toggle") 
    $anim.playback_speed = starting_speed
    $anim.play("default")

func toggle(body):
    
    if (body.name == "hitbox" or body.get_parent().name == "camera"):
        return
    
    if on_light:
        $anim.playback_speed = 7.0
        $orb.modulate = Color(0.6, 1, 1, 1)
    else:
        $anim.playback_speed = starting_speed
        $orb.modulate = Color(1, 1, 1, 1)
    on_light = not on_light
        
    if get_parent().get_parent().get_node("switches") != null:
        for child in get_parent().get_parent().get_node("switches").get_children():
            child.toggle()
