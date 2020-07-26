extends Node2D
class_name Weapon

export var offset = Vector2.ZERO

func _ready():
	position += offset
