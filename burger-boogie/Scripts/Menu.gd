extends Node2D

signal new_game_request
signal quit_request
signal pause_game
signal resume_game

onready var menu_options = [ $new_game/AnimationPlayer, $exit/AnimationPlayer ]
var selected_item   = 0
var unselected_item = 1
var can_toggle = false

func _ready(): 
    update_menu_animations()

func _process(_delta):
    if Input.is_action_just_pressed("toggle_menu") and can_toggle:
        visible = not visible
        if visible:
            get_node("/root/play_scene/audio_player").menu_open()
            emit_signal("pause_game") 
        else: 
            get_node("/root/play_scene/audio_player").menu_close()
            emit_signal("resume_game")
        return
    
    if visible:
        if Input.is_action_just_pressed("ui_accept"):
            get_node("/root/play_scene/audio_player").menu_select()
            if selected_item == 0: emit_signal("new_game_request")
            else:                  emit_signal("quit_request")
            can_toggle = true
            visible    = false
            return
                
        if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
            get_node("/root/play_scene/audio_player").menu_select_change()
            selected_item   = 0 if selected_item == 1 else 1
            unselected_item = 0 if selected_item == 1 else 1
            update_menu_animations()
        
func update_menu_animations():
    menu_options[selected_item].current_animation   = "Selected"
    menu_options[unselected_item].current_animation = "Unselected"

func show_final_score():
    visible = true
    can_toggle = false
    get_node("/root/play_scene/audio_player").game_over()
    emit_signal('pause_game')