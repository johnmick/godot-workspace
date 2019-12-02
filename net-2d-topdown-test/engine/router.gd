extends Node

var connections = {}

func pub(msg_type, msg):
    if connections.has(msg_type):
        for connection in connections[msg_type]:
            connection.call_func(msg)
    
func sub(msg_type, func_ref):
    if connections.has(msg_type) == false:
        connections[msg_type] = []
    connections[msg_type].append(func_ref)

func unsub(msg_type, func_ref):
    if connections.has(msg_type) == false:
        return
    connections[msg_type].erase(func_ref)
