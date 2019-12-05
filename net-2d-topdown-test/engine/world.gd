extends Node

var player_moved_ref    = funcref(self, "player_moved_ref")
var assign_net_uuid_ref = funcref(self, "assign_net_uuid")

func _ready():
    ROUTER.sub("player_moved", player_moved_ref)
    ROUTER.sub("assign_net_uuid", assign_net_uuid_ref)
    

var local_player_id = null
func assign_net_uuid(msg):
    local_player_id = msg["net_uuid"]

var players = {}
func player_moved_ref(msg):
    if local_player_id == msg["net_uuid"]: return
    
    if players.has(msg["net_uuid"]) == false:
        players[msg["net_uuid"]] = preload("res://net_widgets/test_remote_player.tscn").instance()
        add_child(players[msg["net_uuid"]])
        
    players[msg["net_uuid"]].global_transform.origin = msg["position"]
