extends Area2D

export (bool) var disappears = false

func _ready():
    connect("body_entered", self, "body_entered")
    connect("area_entered", self, "area_entered")
    
#func body_entered(body):
#    pass
    
func area_entered(area):
    var area_parent = area.get_parent()
    if area_parent.name == "sword":
        #body_entered(area_parent.get_parent())
        get_node(self.get_path()).body_entered(area_parent.get_parent())
