extends Node2D

signal out_of_hearts

var hearts_left = 3

func new_game():
    $heart_1.visible = true
    $heart_2.visible = true
    $heart_3.visible = true
    hearts_left = 3
    
func lose_a_heart(food_type):
    hearts_left -= 1
    $heart_3.visible = false if hearts_left < 3 else true
    $heart_2.visible = false if hearts_left < 2 else true
    $heart_1.visible = false if hearts_left < 1 else true
    if hearts_left == 0:
        emit_signal("out_of_hearts")