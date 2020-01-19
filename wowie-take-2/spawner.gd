extends Node2D

onready var ball_scene = preload("res://wall.tscn")
onready var ant_scene = preload("res://ant.tscn")
onready var cursor = get_node("player_cursor/CursorSprite")

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)  
    #Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
 


func make_ant():
    var parent = Node2D.new()
    parent.rotation_degrees = 45
    parent.position = position
        
    var initial_velocity = (position - get_viewport().get_mouse_position()).normalized() + linear_velocity    
    var the_ball = ant_scene.instance()
    the_ball.linear_velocity = initial_velocity * -100
    the_ball.angular_velocity = (randf() - .5) * 8 * PI
    the_ball.rotation_degrees = rand_range(0, 360)
    the_ball.leave_time = rand_range(0.05, .5)
    if randf() > .95:
        the_ball.leave_time = rand_range(.5,6)
    parent.add_child(the_ball)
    get_parent().add_child(parent)    
    
func make_ball():
    var parent = Node2D.new()
    parent.rotation_degrees = 45
    parent.position = position
        
    var initial_velocity = (position - get_viewport().get_mouse_position()).normalized() + linear_velocity    
    var the_ball = ball_scene.instance()
    #the_ball.linear_velocity = initial_velocity * -400
    #the_ball.angular_velocity = (randf() - .5) * 8 * PI
    #the_ball.rotation_degrees = rand_range(0, 360)
    parent.add_child(the_ball)
    get_parent().add_child(parent)       

var shoot_interval = 0.1
var shoot_timer    = 0
var MOVE_SPEED =   100
func _input(event):
    #if shoot_timer > shoot_interval and Input.is_action_just_pressed("left_click"):
    #if shoot_timer > shoot_interval and Input.is_action_pressed("left_click"):
    #if Input.is_action_pressed("left_click"):
    #    for x in range(5):
    #        make_ant()
    #    for x in range(10):
    #        make_ball()       
    #    shoot_timer = 0
    pass
    
var spawn_interval = 5
var spawn_timer = 0
var last_position = Vector2.ZERO
var linear_velocity = Vector2.ZERO
func _process(delta):
    var player_delta = Vector2.ZERO
    spawn_timer += delta
    if spawn_timer > spawn_interval:
        position = Vector2(rand_range(20, 600), rand_range(30, 40) * -1)
        for x in range(5):
            make_ant()
        for x in range(50):
            make_ball()          
        spawn_timer = 0
    if Input.is_action_pressed("ui_up"):
        player_delta.y -= MOVE_SPEED * delta
    if Input.is_action_pressed("ui_down"):
        player_delta.y += MOVE_SPEED * delta
    if Input.is_action_pressed("ui_left"):
        player_delta.x -= MOVE_SPEED * delta
    if Input.is_action_pressed("ui_right"):        
        player_delta.x += MOVE_SPEED * delta 
    
    shoot_timer += delta
    linear_velocity = (last_position - position).normalized() * 0.5
    last_position = position
    
    position += player_delta
    $player_cursor.position = get_viewport().get_mouse_position() - position
