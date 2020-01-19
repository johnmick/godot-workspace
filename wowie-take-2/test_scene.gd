extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var ant_scene = preload("res://ant.tscn")
onready var wall_scene = preload("res://wall.tscn")

func ant_maker(x_range, y_range):
    var alt = false
    for x in range(x_range[0], x_range[1], x_range[2]):
        for y in range(y_range[0], y_range[1], y_range[2]):
            var ant = ant_scene.instance()
            ant.position = Vector2(x,y)
            alt = not alt
            add_child(ant)
            #ant.get_node("Sprite/AnimationPlayer").seek(randf())    

func wall_maker(x_range, y_range):
    var alt = false
    for x in range(x_range[0], x_range[1], x_range[2]):
        for y in range(y_range[0], y_range[1], y_range[2]):
            var wall = wall_scene.instance()
            wall.position = Vector2(x,y)
            if alt:
                wall.position.x += int(x_range[2] / 2)
            alt = not alt
            add_child(wall)
            wall.get_node("Sprite/AnimationPlayer").seek(randf()) 
            
# Called when the node enters the scene tree for the first time.

var ant_spawn = [[15,  620,  60], [10, -10, -5]]
func _ready():
    ant_maker(ant_spawn[0], ant_spawn[1])
    wall_maker([5,  610,  40], [100, 300, 25])
    wall_maker([5,  610,  40], [100, 300, 25])

var ant_interval = 1
var ant_timer    = 0
func _process(delta):
   if Input.is_action_pressed("ui_end"):
      get_tree().quit()
    #ant_timer += delta
    #if ant_timer > ant_interval:
    #    ant_maker(ant_spawn[0], ant_spawn[1])
    #    ant_timer = 0
