extends Node2D

var starting_health = 10
var score = 0
var health = starting_health
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var level = 0


onready var anim_players = {
    "arm_right": get_node("arm_right/Sprite/AnimationPlayer"),
    "arm_left":  get_node("arm_left/Sprite/AnimationPlayer"),
    "leg_right": get_node("leg_right/Sprite/AnimationPlayer"),
    "leg_left":  get_node("leg_left/Sprite/AnimationPlayer")
}

onready var bug_spawners = [
    get_node("../bed_bug_spawner1"),
    get_node("../bed_bug_spawner2"),
    get_node("../bed_bug_spawner3"),
    get_node("../bed_bug_spawner4")
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_pressed("ui_left") and not anim_players["leg_left"].is_playing():
        anim_players["leg_left"].seek(0)
        anim_players["leg_left"].play("leg_left_animation")
    if Input.is_action_pressed("ui_right") and not anim_players["leg_right"].is_playing():
        anim_players["leg_right"].seek(0)
        anim_players["leg_right"].play("leg_right_animation")
    if Input.is_action_pressed("ui_up") and not anim_players["arm_right"].is_playing():
        anim_players["arm_right"].seek(0)
        anim_players["arm_right"].play("arm_right_animation")
    #if Input.is_action_pressed("ui_down") and not anim_players["arm_left"].is_playing():
        anim_players["arm_left"].seek(0)
        anim_players["arm_left"].play("arm_left_animation")
    if Input.is_action_pressed("ui_end"):   
        get_tree().quit()
        
    var current_level = score / 10
    if current_level > level:
        level += 1
        for spawner in bug_spawners:
            spawner.velocity_x *= 1.2
            spawner.spawn_interval_min *= .7
            spawner.spawn_interval_max *= .7

        
    if health < 1:
        if rand_range(1,100) > rand_range(10,30):
            get_node("AudioStreamPlayer2D").pitch_scale = rand_range(.2,.6)
            get_node("AudioStreamPlayer2D").seek(0)
            get_node("AudioStreamPlayer2D").play()    
        rotation_degrees += 175 * delta
        
        
        if rotation_degrees > 360*4:
            health = starting_health
            modulate = Color.white
            rotation_degrees = 0
            level = 0
            score = 0
            for spawner in bug_spawners:
                spawner.velocity_x = spawner.original_velocity_x
                spawner.spawn_interval_min = spawner.original_spawn_interval_min
                spawner.spawn_interval_max = spawner.original_spawn_interval_max
