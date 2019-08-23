extends Node2D

signal dance_floor_is_broken

export var number_lights_per_drop = 5 # Number of lights to turn off per food hit
const FLOOR_CAN_TAKE      = 58  # Number of lights out before gameover
var outage_lights         = []  # Collection of lights for visibility toggles
var floor_hits            = 0   # Number of current hits
var floor_hit_colors = {
        1: Color(0, .5, 0, 0.9),    # growth
        2: Color(255, .5, 0, 0.9) ,  # burger
        3: Color(.75, .5, .1, 0.9) ,  # donut
        4: Color(1, 1, 0, 0.9) # pizza
    }

func _ready():
    var i = 1
    while i <= FLOOR_CAN_TAKE:
        outage_lights.append(get_node("Floor Outage Lights/outage_" + str(i)))
        i += 1

func food_hit_the_floor(food_type):
    var i = 0
    while i < number_lights_per_drop:
        if floor_hits + i >= FLOOR_CAN_TAKE:
            break
        outage_lights[floor_hits +i].modulate = floor_hit_colors[food_type]
        outage_lights[floor_hits + i].visible = true
        
        i += 1 
    floor_hits +=  number_lights_per_drop
    if floor_hits >= FLOOR_CAN_TAKE:
        emit_signal("dance_floor_is_broken")
               

func turn_on_the_lights():
    floor_hits = 0
    for outage_light in outage_lights: outage_light.visible = false