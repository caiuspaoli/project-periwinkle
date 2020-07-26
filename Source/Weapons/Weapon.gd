extends Node2D
class_name Weapon

export var offset = Vector2.ZERO

export var clipSize = 8
export(int) var ammo = clipSize
export var reserveAmmo = 56

func _ready():
	position += offset
