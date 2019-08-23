extends Node2D

export var value = 0

var digit = preload("res://Scenes/dynamic_digit.tscn")
onready var current_digit_container = Node.new()

func _ready():
    set_score(0)
    
func set_score(score):
    value = score
    current_digit_container.queue_free()
    var digit_container = Node.new()
    var i = 0
    for s in str(value):
        var new_digit = digit.instance()
        new_digit.digit = s
        new_digit.position = Vector2(position.x + i * 6, position.y)
        new_digit.name = s
        digit_container.add_child(new_digit)
        i += 1
    add_child(digit_container)
    current_digit_container = digit_container

func new_game():
    value = 0
    set_score(value)
    
func increment_score():
    value += 1
    set_score(value)