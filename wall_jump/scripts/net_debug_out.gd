extends Node

export(String)     var dest_address
export(int)        var dest_port
export(Dictionary) var targets


var socketUDP:PacketPeerUDP

func _ready():
    socketUDP = PacketPeerUDP.new()
    socketUDP.set_dest_address(dest_address, dest_port)

func _process(_delta):
    var msg = {}
    for target_object in targets:
        msg[target_object] = {}
        
        for target_param in targets[target_object]:
            var target_ref = get_node(target_object)[target_param]
            if typeof(target_ref) == TYPE_VECTOR2:
                msg[target_object][target_param] = {
                    "x": target_ref.x,
                    "y": target_ref.y,
                }
            else:
                push_error("Attempting to serialize an unsupported datatype")
    
    socketUDP.put_packet(to_json(msg).to_utf8())
