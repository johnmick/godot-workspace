extends Area2D

# warning-ignore:unused_class_variable
export (bool) var disappears = false

func _ready():
    UTIL.checked_connect(self, "body_entered", self, "body_entered")
    UTIL.checked_connect(self, "area_entered", self, "area_entered")
    
func area_entered(area):
    var area_parent = area.get_parent()
    if area_parent.name == "sword":
        #body_entered(area_parent.get_parent())
        get_node(self.get_path()).body_entered(area_parent.get_parent())
