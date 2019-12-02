extends StaticBody2D

export (bool) var on_light = true

var starting_speed = 3

func sword_area_entered(msg):
    if msg.area == $hitbox:
        toggle()

var sword_area_entered_ref = funcref(self, "sword_area_entered")

func _ready():
    ROUTER.sub("sword_area_entered", sword_area_entered_ref)
    $anim.playback_speed = starting_speed
    $anim.play("default")

func toggle():  
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
