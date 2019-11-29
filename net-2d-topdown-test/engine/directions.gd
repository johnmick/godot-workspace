extends Node

const CENTER = Vector2(0,0)
const LEFT   = Vector2(-1,0)
const RIGHT  = Vector2(1,0)
const UP     = Vector2(0,-1)
const DOWN   = Vector2(0,1)

const directions = [ LEFT, RIGHT, UP, DOWN ]
func rand():
    return directions[randi() % 4]
