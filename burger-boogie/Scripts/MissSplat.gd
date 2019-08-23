extends Node2D

onready var timer = $timer
var floor_hit_colors = {
        1: Color(0, .8, 0, 1.0),   # growth
        2: Color(1, .5, .4, 1.0) ,  # burger
        3: Color(1, .5, .5, 1.0),   # donut
        4: Color(1, 1, 0, 1.0) # pizza
    }
func _ready():
    timer.connect("timeout", self, "miss_timeout")

func food_missed(food_type):
    visible = true
    modulate = floor_hit_colors[food_type]
    timer.start()

func miss_timeout():
    visible = false