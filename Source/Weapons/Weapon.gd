extends Node2D
class_name Weapon

export(Texture) var itemTexture

export var offset = Vector2.ZERO

export var screenShakeTrauma = 0.0
export var chromaticAberrationDuration = 0.0
export var slowTimeDuration = 0.0
export var slowTimeStrength = 0.0

var ammo = 0
export var clipSize = 0
export var reserveAmmo = 0

onready var root = get_tree().root
onready var parent = get_parent()
onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var camera = parent.get_node("Camera")
onready var slowTime = get_node("/root/Game/Effects/SlowTime")


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

func _shoot():
	camera.set_trauma(screenShakeTrauma)
	camera.chromatic_aberration(chromaticAberrationDuration)
	slowTime.start(slowTimeDuration, slowTimeStrength)
