extends Node2D

signal food_matched(food, position)
signal pause_game()
signal new_wave_begin()
signal resume_game()

var foods = [
    preload("res://Scenes/Symbols/burger.tscn"),
    preload("res://Scenes/Symbols/donut.tscn"),
    preload("res://Scenes/Symbols/pizza.tscn"),
    preload("res://Scenes/Symbols/growth.tscn"),
    preload("res://Scenes/Symbols/sushi.tscn"),
]
var current_level  = 0
var base_x_offset  = 21
var base_y_offset  = -1

var x_offset_delta = 11
var y_offset_delta = 20

var y_rate_multi   = 1.0000015
var y_rate_base    = 1.15

var foods_left     = 0

onready var events = [
    { "src_node":menu, "src_event":"pause_game",       "dst_node":self, "dst_func":"pause_game"        },
    { "src_node":menu, "src_event":"resume_game",      "dst_node":self, "dst_func":"resume_game"       },
    { "src_node":menu, "src_event":"new_game_request", "dst_node":self, "dst_func":"new_game_request"  },
]

func _ready():
    randomize()
    for event in events: if event.src_node.connect(event.src_event, event.dst_node, event.dst_func) != 0:
        print("Error binding %s:%s to %s:%s" % [event.src_node.name, event.src_event, event.dst_node.name, event.dst_func])    
    
func new_game_request():
    for child in get_children():
        child.queue_free()
    current_level = 0
    foods_left    = 0

func pause_game():
    emit_signal("pause_game")
    
func resume_game():
    emit_signal("resume_game")

func start_next_level():
    emit_signal("new_wave_begin")
    get_node("/root/play_scene/audio_player").new_wave_begin()
    current_level += 1
    for i in range(current_level):
        for n in range(4):
            var food = foods[randi()%5].instance()
            food.position = Vector2(base_x_offset + x_offset_delta * n, base_y_offset - y_offset_delta * i)
            food.y_rate   = y_rate_base * y_rate_multi * current_level
            food.connect("food_matched", self, "food_match")
            call_deferred('add_child', food)
            foods_left += 1
            
func food_match(food, position):
    emit_signal("food_matched", food, position)
    
    foods_left -= 1
    if foods_left <= 0:
        start_next_level()
        
func game_over():
    menu.show_final_score()