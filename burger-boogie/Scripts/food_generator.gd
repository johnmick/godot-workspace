extends Node2D

signal new_food_generated(new_food)

export var food_drop_rate = 40.0
export var arrow_out_at_y  = 40.0
export var time_between_spawns = 2.5
export var food_spawn_position = Vector2(33, -10)

var food_container   = null
var paused           = true
var time_since_spawn = 0.0

onready var foods = [
    preload("res://Scenes/Symbols/Burger.tscn"),
    preload("res://Scenes/Symbols/Growth.tscn"),
    preload("res://Scenes/Symbols/Donut.tscn"),
    preload("res://Scenes/Symbols/Pizza.tscn")
]
onready var num_of_foods = foods.size()

func _ready():
    reset_foods()

func _process(delta):
    if paused: return
    
    time_since_spawn += delta
    if time_since_spawn > time_between_spawns:
        time_since_spawn = 0.0
        var new_food      = foods[randi() % num_of_foods - 1].instance()
        new_food.position = food_spawn_position
        new_food.y_rate   = food_drop_rate
        new_food.arrow_out_at_y = arrow_out_at_y
        food_container.add_child(new_food)
        emit_signal("new_food_generated", new_food)

func reset_foods():
    if food_container != null:
        food_container.queue_free()
    food_container = Node2D.new()
    food_container.name = "food_container"
    add_child(food_container)
    
func start_generating_food(): paused = false
func stop_generating_food():  paused = true