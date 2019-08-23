extends Node2D

var paused = true
onready var level_manager = $level_manager
onready var player_score  = $player_score

onready var events = [
    # Events from the Menu
    { "src_node":menu, "src_event":"new_game_request", "dst_node":self, "dst_func":"new_game_request"             },
    { "src_node":menu, "src_event":"pause_game",       "dst_node":self, "dst_func":"pause_game"                   },
    { "src_node":menu, "src_event":"resume_game",      "dst_node":self, "dst_func":"resume_game"                  },
    { "src_node":menu, "src_event":"quit_request",     "dst_node":self, "dst_func":"quit_game"                    },
    
    # Events from the Level manager
    { "src_node":$level_manager, "src_event":"food_matched",   "dst_node":self, "dst_func":"food_matched"         },
    
    # Events from the Player
    { "src_node":$player, "src_event":"new_game_ready",           "dst_node":self, "dst_func":"new_game_ready"    },
    { "src_node":$player, "src_event":"player_spit_food",         "dst_node":self, "dst_func":"food_spit"         },
    { "src_node":$player, "src_event":"player_food_type_changed", "dst_node":self, "dst_func":"food_type_changed" },
    { "src_node":$player, "src_event":"game_over",                "dst_node":menu, "dst_func":"show_final_score"  }
]
func _ready():
    for event in events: if event.src_node.connect(event.src_event, event.dst_node, event.dst_func) != 0:
        print("Error binding %s:%s to %s:%s" % [event.src_node.name, event.src_event, event.dst_node.name, event.dst_func])

func new_game_request(): 
    player_score.set_score(0)
    resume_game()
    
func new_game_ready():
    level_manager.start_next_level()
    
func food_spit(food):
    get_parent().add_child(food)
 

var food_indices = {
    "burger": 0,
    "donut": 1,
    "pizza": 2,
    "growth": 3,
    "sushi":  4
}
var food_alphas = [ 0.4, 0.7, 1.0, 0.7, 0.4 ]
var food_y_offsets = [ 51, 42, 33, 24, 15 ]
var foods = RESOURCES.foods

var glowing = preload("res://Scenes/Symbols/glowing.tscn")
func food_type_changed(food):
    for child in $food_type_indicator.get_children():
        child.queue_free()
    var current_food_index = food_indices[food.food_name]
    
    var food_indices = []
    for i in range(current_food_index, foods.size()):
        food_indices.append(i)
    for i in range(0, current_food_index):
        food_indices.append(i)
    
    var glow = glowing.instance()
    glow.position = Vector2(0, 33)
    $food_type_indicator.add_child(glow)
    
    var the_food = foods[food_indices[0]].instance()
    the_food.position = Vector2(0, food_y_offsets[2])
    the_food.modulate = Color(1, 1, 1, food_alphas[2])
    $food_type_indicator.add_child(the_food)
    
    the_food = foods[food_indices[4]].instance()
    the_food.position = Vector2(0, food_y_offsets[3])
    the_food.modulate = Color(1, 1, 1, food_alphas[3])
    $food_type_indicator.add_child(the_food)
    
    the_food = foods[food_indices[1]].instance()
    the_food.position = Vector2(0, food_y_offsets[1])
    the_food.modulate = Color(1, 1, 1, food_alphas[1])
    $food_type_indicator.add_child(the_food)
    
    the_food = foods[food_indices[3]].instance()
    the_food.position = Vector2(0, food_y_offsets[4])
    the_food.modulate = Color(1, 1, 1, food_alphas[4])
    $food_type_indicator.add_child(the_food)
    
    the_food = foods[food_indices[2]].instance()
    the_food.position = Vector2(0, food_y_offsets[0])
    the_food.modulate = Color(1, 1, 1, food_alphas[0])
    $food_type_indicator.add_child(the_food)
    
    
func food_matched(_food, _position):
    player_score.increment_score()
    
func pause_game():  paused = true      
func resume_game(): paused = false        
func quit_game():   get_tree().quit()