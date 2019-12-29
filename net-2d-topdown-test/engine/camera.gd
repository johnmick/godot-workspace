extends Camera2D

func _ready():
    UTIL.checked_connect($area, "body_entered", self, "body_entered")
    UTIL.checked_connect($area, "body_exited", self, "body_exited")
    UTIL.checked_connect($area, "area_exited", self, "area_exited")

func _process(_delta):
    var pos = get_node("../player").global_position - Vector2(0, 32)
    var x = floor(pos.x / 320) * 320
    var y = floor(pos.y / 256) * 256 # 144 - 16
    global_position = Vector2(x,y)

func body_entered(body):
    if body.get("TYPE") == "ENEMY" or body.get("TYPE") == "toggler":
        #print("Enabled Monster", body)
        body.set_physics_process(true)
    
func body_exited(body):
    if body.get("TYPE") == "ENEMY":
        #print("Turned monster Off", body)
        body.set_physics_process(false)

func area_exited(area):
    if area.get("disappears") == true:
        area.queue_free()
