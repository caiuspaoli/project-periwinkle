extends Weapon

export var explosionScene = preload("res://Source/Weapons/Launcher/LauncherExplosion.tscn")

export var barrelOffset = Vector2(12, 0)

export var recoilSpeed = 256

export var screenShakeTrauma = 0.4
export var chromaticAberrationDuration = 0.3
export var slowTimeDuration = 0.0
export var slowTimeStrength = 0.0

onready var root = get_tree().root
onready var parent = get_parent()
onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var camera = get_parent().get_node("Camera")
onready var slowTime = get_node("/root/Game/Effects/SlowTime")

func shoot():
	apply_recoil()
	create_explosion()
	camera.set_trauma(screenShakeTrauma)
	camera.chromatic_aberration(chromaticAberrationDuration)
	slowTime.start(slowTimeDuration, slowTimeStrength)

func apply_recoil():
	parent.stateMachine.apply_recoil(-recoilSpeed * Vector2(cos(rotation), sin(rotation)))

func create_explosion():
	var barrelPosition = Vector2.ZERO
	barrelPosition.x = global_position.x + (barrelOffset.x * cos(rotation) - barrelOffset.y * sin(rotation))
	barrelPosition.y = global_position.y + (barrelOffset.x * sin(rotation) + barrelOffset.y * cos(rotation))
	
	var explosion = explosionScene.instance()
	explosion.position = barrelPosition
	root.add_child(explosion)
