extends Node

var configured = false

var network_uuid           = null
var network_uuid_requested = false

var SERVER_IP = "data-vis.tk"
var SERVER_PORT = 4242
var socketUDP   = PacketPeerUDP.new()
var socketTCP   = StreamPeerTCP.new()


func _ready():
    if connect_tcp_client() == OK:
        print('TCP Connected')
    
func _process(_delta):
    if socketTCP.is_connected_to_host() == true and network_uuid_requested == false:
        request_network_uuid()

    if not configured and network_uuid != null:
        configure_udp_client()
    
    if socketTCP.is_connected_to_host():
        if socketTCP.get_available_bytes() != 0:
            var msg = socketTCP.get_var()
            print('[TCP] ', msg)
            ROUTER.pub(msg["type"], msg)
            
    if socketUDP.get_available_packet_count() > 0:
        var msg = socketUDP.get_var()
        print('[UDP] ', msg)
        ROUTER.pub(msg["type"], msg)
        

func connect_tcp_client():
    var status = socketTCP.connect_to_host(SERVER_IP, SERVER_PORT)

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
