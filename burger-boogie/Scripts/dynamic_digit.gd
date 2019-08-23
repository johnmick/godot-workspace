extends Node2D

export var digit = 0

func _ready():
    $AnimatedSprite.animation = str(digit)