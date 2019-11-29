extends Node

var items = {
    "SWORD": preload("res://items/sword.tscn")
}

func create_sword(sword_owner, sword_direction):
    var new_sword         = items["SWORD"].instance()
    new_sword.SWORD_OWNER = sword_owner
    new_sword.DIRECTION   = sword_direction
    
    return new_sword
