extends Node

signal assign_net_uuid
signal hello_udp

var configured = false

var network_uuid           = null
var network_uuid_requested = false

var SERVER_IP = "data-vis.tk"
var SERVER_PORT = 4242
var socketUDP   = PacketPeerUDP.new()
var socketTCP   = StreamPeerTCP.new()


func _ready():
    connect("assign_net_uuid", self, "assign_net_uuid")
    connect("hello_udp", self, "hello_udp")
    if connect_tcp_client() == OK:
        print('TCP Connected')
    
func _process(delta):
    if socketTCP.is_connected_to_host() == true and network_uuid_requested == false:
        request_network_uuid()

    if not configured and network_uuid != null:
        configure_udp_client()
    
    if socketTCP.is_connected_to_host():
        if socketTCP.get_available_bytes() != 0:
            var msg = socketTCP.get_var()
            emit_signal(msg["type"], msg)
            
    if socketUDP.get_available_packet_count() > 0:
        var msg = socketUDP.get_var()
        print(msg)
        emit_signal(msg["type"], msg)

    #print(socketTCP.get_status())
    #if socketTCP.get_status() in [0, 3]:
    #    connect_tcp_client()

func connect_tcp_client():
    var status = socketTCP.connect_to_host(SERVER_IP, SERVER_PORT)
    if status == OK:
        socketTCP.set_no_delay(true)

    return status   

func configure_udp_client():
    print("[UDP] Attempting to configure")
    if socketUDP.set_dest_address(SERVER_IP, SERVER_PORT) != OK:
        print("[UDP] Error setting dest address on port: " + str(SERVER_PORT) + " in server: " + SERVER_IP)
        return false
    
    if socketUDP.listen(SERVER_PORT) != OK:
        print("[UDP] Error listening on port: " + str(SERVER_PORT))
        return false
        
    socketUDP.put_var({
        "type": "join_udp",
        "uuid": network_uuid    
    })
    configured = true
    return configured

func request_network_uuid():
    socketTCP.put_var({"type": "net_request_id"})
    network_uuid_requested = true

func assign_net_uuid(net_uuid):
    network_uuid = net_uuid
    
func hello_udp(msg):
    print('Hello incoming UDP', msg)

func _exit_tree():
    socketUDP.close()

#var peer = null
#var connected = false

#func _ready():
    #peer = NetworkedMultiplayerENet.new()
    #peer.create_client('45.55.34.139', 4242)
    #get_tree().set_network_peer(peer)
    #get_tree().connect("network_peer_connected", self, "network_peer_connected")
    
#func network_peer_connected(id):
#    connected = true
#    print("Connected", id)
    
    
    
