extends Area2D

onready var base_position = position

signal food_matched(food, position)
signal food_mismatch()


export var food_name = "set_food_name"

var accumulated_delta = Vector2(0, 0)
var x_rate = 0
export var y_rate = -20.0
var game_over_y    = 52
var paused = false
var was_spit = false

onready var events = [
    { "src_node":self, "src_event":"area_entered",     "dst_node":self, "dst_func":"something_entered" },
    { "src_node":menu, "src_event":"pause_game",       "dst_node":self, "dst_func":"pause_game"        },
    { "src_node":menu, "src_event":"resume_game",      "dst_node":self, "dst_func":"resume_game"       },
    { "src_node":menu, "src_event":"new_game_request", "dst_node":self, "dst_func":"new_game_request"  },
]
func _ready():
    for event in events: if event.src_node.connect(event.src_event, event.dst_node, event.dst_func) != 0:
        print("Error binding %s:%s to %s:%s" % [event.src_node.name, event.src_event, event.dst_node.name, event.dst_func])
    
func something_entered(other):
    if other.food_name == food_name:
        other.call_deferred("free")
        self.call_deferred("free")
        emit_signal("food_matched", food_name, position)
        get_node("/root/play_scene/audio_player").food_matched()
    else:
        if was_spit:
            emit_signal("food_mismatch")
            get_node("/root/play_scene/audio_player").food_mismatch()
            #queue_free()
            y_rate = other.y_rate
            was_spit = false
            position = Vector2(position.x, other.position.y + 10)
            base_position = position
            accumulated_delta = Vector2(0,0)

func _process(delta):
    if paused: 
        return
    accumulated_delta += Vector2(delta * x_rate, delta * y_rate)

    var new_position = base_position + accumulated_delta
    position = Vector2(int(new_position.x), int(new_position.y))
    
    
    if position.y > game_over_y:
        menu.show_final_score()
        #emit_signal("game_over")
    if position.y < 0 and was_spit:
        queue_free()
    
func pause_game(): 
    paused = true
    
func resume_game(): 
    paused = false
    
func new_game_request():
    queue_free()