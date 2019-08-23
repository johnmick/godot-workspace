extends Node2D

signal player_position_changed(position)
signal player_food_type_changed(food)
signal player_spit_food(food)
signal new_game_ready()
signal game_over()

export var spit_timer_wait_time = 1.0
export var food_spit_y_rate     = -60

onready var base_position     = position
onready var spit_timer        = $spit_timer
onready var animation         = $AnimationPlayer

var position_offsets = [
    # Vector2(-22, 0),
    Vector2(-11, 0),
    Vector2(  0, 0),
    Vector2( 11, 0),
    Vector2( 22, 0)
]
var current_position_offset = 1
var foods = [
    preload("res://Scenes/Symbols/burger.tscn"),
    preload("res://Scenes/Symbols/donut.tscn"),
    preload("res://Scenes/Symbols/pizza.tscn"),
    preload("res://Scenes/Symbols/growth.tscn"),
    preload("res://Scenes/Symbols/sushi.tscn"),
]
var current_food_type = 0

var paused = true
onready var events = [
   # { "src_node":self,      "src_event":"player_position_changed", "dst_node":self, "dst_func":"on_player_position_changed" },
    { "src_node":animation, "src_event":"animation_finished",      "dst_node":self, "dst_func":"animation_finished"         },
    { "src_node":menu,      "src_event":"new_game_request",        "dst_node":self, "dst_func":"new_game"                   },
    { "src_node":menu,      "src_event":"pause_game",              "dst_node":self, "dst_func":"pause_game"                 },
    { "src_node":menu,      "src_event":"resume_game",             "dst_node":self, "dst_func":"resume_game"                },
]

func _ready():
    spit_timer.wait_time = spit_timer_wait_time
    for event in events: if event.src_node.connect(event.src_event, event.dst_node, event.dst_func) != 0:
       print("Error binding %s:%s to %s:%s" % [event.src_node.name, event.src_event, event.dst_node.name, event.dst_func])    
    
func _process(_delta):
    if paused: return
    
    var new_pos_offset = current_position_offset
    if Input.is_action_just_pressed("ui_left"):  new_pos_offset -= 1
    if Input.is_action_just_pressed('ui_right'): new_pos_offset += 1
    
    if new_pos_offset != current_position_offset:
        get_node("/root/play_scene/audio_player").player_move()
        if new_pos_offset < 0:
            new_pos_offset = position_offsets.size() - 1
        elif new_pos_offset >= position_offsets.size():
            new_pos_offset = 0
        position = base_position + position_offsets[new_pos_offset]
        current_position_offset = new_pos_offset
        emit_signal("player_position_changed", position)
        
    if Input.is_action_just_pressed("ui_down"):
        get_node("/root/play_scene/audio_player").food_select_change()
        current_food_type += 1
        if current_food_type >= foods.size():
            current_food_type = 0
        emit_signal("player_food_type_changed", foods[current_food_type].instance())
    if Input.is_action_just_pressed("ui_up"):
        get_node("/root/play_scene/audio_player").food_select_change()
        current_food_type -= 1
        if current_food_type < 0:
            current_food_type = foods.size() - 1
        emit_signal("player_food_type_changed", foods[current_food_type].instance())        
    
    if Input.is_action_just_pressed("ui_accept"):
        get_node("/root/play_scene/audio_player").monster_start_spit()
        animation.play("spit_food")
        
        
func new_game(): 
    animation.play("player_enter")
    

func animation_finished(animation_name):
    if animation_name == "player_enter":
        resume_game()
        emit_signal("player_food_type_changed", foods[current_food_type].instance())
        emit_signal("new_game_ready")
    elif animation_name == "spit_food":
        var food = foods[current_food_type].instance()
        food.position = Vector2(position.x, 51)
        food.y_rate   = food_spit_y_rate
        food.was_spit = true       
        get_node("/root/play_scene/audio_player").monster_spit()
        emit_signal("player_spit_food", food)        
        animation.play("spit_food_close")
    elif animation_name == "spit_food_close":
        get_node("/root/play_scene/audio_player").monster_end_spit()

func game_over():
    emit_signal("game_over")

func resume_game(): paused = false
func pause_game():  paused = true