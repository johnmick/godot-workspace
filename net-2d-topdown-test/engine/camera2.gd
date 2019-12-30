extends Camera2D

func _ready():
    UTIL.checked_connect($area, "body_entered", self, "body_entered")
    UTIL.checked_connect($area, "body_exited", self, "body_exited")
    UTIL.checked_connect($area, "area_exited", self, "area_exited")

var from_pos = Vector2(0, 0)
var to_pos   = Vector2(0, 0)
var x_lerp_weight = 0
var y_lerp_weight = 0
var x_lerp_weight_rate = 0.5
var y_lerp_weight_rate = 0.5
var time_between = 1
var time_counter = 0

func _process(delta):
    var current_player_pos = get_node("../player").global_position
    global_position = current_player_pos - Vector2(160, 160)
        

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
