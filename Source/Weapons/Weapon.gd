extends Node2D
class_name Weapon

export(AudioStream) var failSound = preload("res://Source/Weapons/WeaponFailSound.wav")
export(AudioStream) var shootSound

export(Texture) var itemTexture

export var offset = Vector2.ZERO

export var screenShakeTrauma = 0.0
export var chromaticAberrationDuration = 0.0
export var slowTimeDuration = 0.0
export var slowTimeStrength = 0.0

export var cooldownTime = 0.0
export var reloadTime = 0.0

var ammo = 0
export var clipSize = 0
export var reserveAmmo = 0

onready var root = get_tree().root
onready var soundFxController = root.get_node("Game/SoundFxController")
onready var slowTime = root.get_node("Game/Effects/SlowTime")

onready var parent = get_parent()
onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var camera = parent.get_node("Camera")


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
	soundFxController.play(shootSound)
	camera.set_trauma(screenShakeTrauma)
	camera.chromatic_aberration(chromaticAberrationDuration)
	slowTime.start(slowTimeDuration, slowTimeStrength)
