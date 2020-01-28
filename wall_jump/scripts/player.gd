extends KinematicBody2D

export var SPEED = 4000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time_alive = 0
var data_file = null
var data_to_write = {
    "time":           [],
    "acceleration_x": [],
    "acceleration_y": [],
    "velocity_x":     [],
    "velocity_y":     [],
    "position_x":     [],
    "position_y":     []
   }
# Called when the node enters the scene tree for the first time.
func _ready():
    data_file = File.new()
    data_file.open("user://player_data.dat", File.WRITE)    

var max_jump_time = .85
var jump_timer    = 0
var jumping       = false
var wall_jumped   = false
var wall_jump_timer = 0
var wall_jump_interval = .2

var first_cut_process_enabled  = false
var second_cut_process_enabled = true

func _physics_process(delta):
    if first_cut_process_enabled:
        first_cut_process(delta)
        
    if second_cut_process_enabled:
        second_cut_process(delta)

# running state
#var acceleration_scale  = Vector2(0.5,  1)
#var acceleration_extent = Vector2(10, 100)
#var velocity_extent     = Vector2(600, 800)

# walking state
var acceleration_scale  = Vector2(5,  1)
var acceleration_extent = Vector2(25, 100)
var velocity_extent     = Vector2(600, 800)
var gravity             = Vector2(0,0)
var drag                = .85

var acceleration = Vector2.ZERO
var velocity     = Vector2.ZERO
var speed        = Vector2.ZERO

var state_on_ground  = false
var state_is_running = false
var state_is_jumping = false
var state_just_wall_jumped = false
var new_state        = false

func _notification(what):
    if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
        data_file.store_line(to_json(data_to_write))
        data_file.close()
        get_tree().quit() # default behavior
        

var was_on_floor = false
func second_cut_process(delta):
    time_alive += delta
    
    new_state = false
    var apply_drag = true
    # Apply Reduced Acceleration due to Drag #################################################
    #acceleration = acceleration * drag
    if is_on_floor() == false:
        acceleration = gravity
    else:
        if state_is_jumping:
            state_is_jumping = false
            new_state = true
            
        if Input.is_action_just_pressed("jump") and not state_is_jumping:
            state_is_jumping = true     
            new_state  = true   
    
    # Apply Added Acceleration from User Requests #################################################
    if Input.is_action_pressed("ui_left"):
        acceleration += acceleration_scale.x * Vector2(-1, 0)
        apply_drag = false
        state_is_running = true
        new_state = true
        
    if Input.is_action_pressed("ui_right"):        
        acceleration += acceleration_scale.x * Vector2(1, 0)
        state_is_running = true
        apply_drag = false
        new_state = true
    

        
    # Bound Max Acceleration #################################################
    if acceleration.x > acceleration_extent.x:
        acceleration.x = acceleration_extent.x
    elif acceleration.x < -acceleration_extent.x:
        acceleration.x = -acceleration_extent.x        
    if acceleration.y > acceleration_extent.y:
        acceleration.y = acceleration_extent.y     
    elif acceleration.y < -acceleration_extent.y:
        acceleration.y = -acceleration_extent.y    
        

    # Advance Velocity/Speed  #################################################                 
    velocity += acceleration
    
    if is_on_floor():
        velocity.y = 0    
    
    if apply_drag:
        velocity.x  = velocity.x * drag
        acceleration.x = acceleration.x * drag

    # Bound Max Velocity #################################################
    if velocity.x > velocity_extent.x:
        velocity.x = velocity_extent.x
    elif velocity.x < -velocity_extent.x:
        velocity.x = -velocity_extent.x        
    #if velocity.y > velocity_extent.y:
    #    velocity.y = velocity_extent.y     
    #elif velocity.y < -velocity_extent.y:
    #    velocity.y = -velocity_extent.y    

    # Jumps override bounding
    if state_is_jumping:
        if is_on_wall() and Input.is_action_just_pressed("jump") and not is_on_floor():
            velocity.y = -3815
            velocity.x = 600 * (1 if velocity.x < 0 else -1)
            acceleration.x = 0
            acceleration.y = 0
            jump_timer = 0
            state_just_wall_jumped = true
            new_state = true
            $jump_sound.play()
            get_node("/root/main_scene/Camera2D").flash_pause()
            
        velocity.y = -315
        jump_timer += delta
        if jump_timer > max_jump_time:
            jump_timer = 0
            state_is_jumping = false    

    if state_is_jumping and velocity.x > 0:
        $Node2D/Sprite.flip_h = false
    elif state_is_jumping:
        $Node2D/Sprite.flip_h = true
    elif velocity.x > 0:
        $Node2D/Sprite.flip_h = true
    else:
        $Node2D/Sprite.flip_h = false
    
    if abs(velocity.x) < 20:
        state_is_running = false
        new_state = true
        
    if state_just_wall_jumped:
        wall_jump_timer += delta
        if wall_jump_timer > wall_jump_interval:
            wall_jump_timer = 0
            state_just_wall_jumped = false        
                    
    # Set animation
    if new_state:
        if state_just_wall_jumped:
            $Node2D/AnimationPlayer.play("player_wall_jump_pose")
        elif state_is_jumping:
            $Node2D/AnimationPlayer.play("player_spinjumping")
        elif state_is_running:
            $Node2D/AnimationPlayer.play("player_running")
        else:
            $Node2D/AnimationPlayer.play("player_standing")
     
    if state_is_running:
        $Node2D/AnimationPlayer.playback_speed = lerp(
            0.5,
            0.75,
            abs(velocity.x) / 300
        )
        print(abs(velocity.x), ':', $Node2D/AnimationPlayer.playback_speed)
        #$Node2D/AnimationPlayer.playback_speed = velocity.length()
   
    # Update Position
    if is_on_floor() and was_on_floor:
        velocity.y = 0
        acceleration.y = 0
    move_and_slide(velocity, Vector2(0, -1))
    
    data_to_write["acceleration_x"].append(acceleration.x)
    data_to_write["acceleration_y"].append(acceleration.y)
    data_to_write["velocity_x"].append(velocity.x)
    data_to_write["velocity_y"].append(velocity.y)
    data_to_write["position_x"].append(position.x)
    data_to_write["position_y"].append(position.y)
    data_to_write["time"].append(time_alive)
    
    was_on_floor = is_on_floor()
    #var collision_object = move_and_collide(speed, true, true, true)
    #if collision_object and collision_object.collider.name != "ground":
    #    print(collision_object.collider.name)
    #    speed        = Vector2(0, speed.y)
    #    velocity     = Vector2(0, velocity.y)
    #    acceleration = Vector2(0, acceleration.y)     
    #else:
    #    acceleration += Vector2(0, 5000 * delta)
    #move_and_collide(speed)
    

func first_cut_process(delta):
    var move_direction = Vector2.ZERO
    var running = false
    if Input.is_action_pressed("ui_left"):
        move_direction += Vector2(-1.5, 0)
        
        if wall_jumped == false:
            $Node2D/Sprite.flip_h = false
            running = true
        
    if Input.is_action_pressed("ui_right"):
        move_direction += Vector2(1.5, 0)
        if wall_jumped == false:
            $Node2D/Sprite.flip_h = true
            running = true
        
    if is_on_floor() and Input.is_action_just_pressed("jump"):
        jumping = true
    
    if jumping:
        if is_on_wall() and Input.is_action_pressed("jump"):
            move_direction = Vector2(move_direction.x * -5, -14)
            jump_timer = 0
            wall_jumped = true
            $Node2D/Sprite.flip_h = not $Node2D/Sprite.flip_h
        elif max_jump_time > jump_timer:
            move_direction += Vector2(0, -14)
            jump_timer     += delta
        elif is_on_floor():
            jumping = false
            wall_jumped = false
            wall_jump_timer = 0            
            jump_timer = 0
        
    if wall_jumped:
        wall_jump_timer += delta
        if wall_jump_timer < wall_jump_interval:
            $Node2D/AnimationPlayer.play("player_wall_jump_pose")
        else:
            $Node2D/AnimationPlayer.play("player_spinjumping")
            wall_jumped = false
            wall_jump_timer = 0
    elif running and not jumping:
        $Node2D/AnimationPlayer.play("player_running")
    elif jumping:
        $Node2D/AnimationPlayer.play("player_spinjumping")
        
    if move_direction == Vector2.ZERO:
        $Node2D/AnimationPlayer.play("player_standing")
    
    var movement = move_direction * SPEED * delta
    movement += Vector2(0, 5) * SPEED * delta
    
    movement = Vector2(int(movement.x), int(movement.y))    
    move_and_slide(movement, Vector2(0, -1))
