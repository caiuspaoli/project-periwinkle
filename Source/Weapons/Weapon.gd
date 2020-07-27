extends Node2D
class_name Weapon

export(Texture) var itemTexture

export var offset = Vector2.ZERO

var ammo = 0
export var clipSize = 0
export var reserveAmmo = 0

func _setup(_ammo, _clipSize, _reserveAmmo):
	ammo = _ammo
	clipSize = _clipSize
	reserveAmmo = _reserveAmmo 
	
	var target = min(clipSize, reserveAmmo)
	ammo -= target
	reserveAmmo += target

func _ready():
	position += offset
	
	var target = min(clipSize, reserveAmmo)
	ammo += target
	reserveAmmo -= target
