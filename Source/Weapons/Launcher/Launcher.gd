extends Weapon

export var explosionScene = preload("res://Source/Weapons/Launcher/LauncherExplosion.tscn")

export var recoilSpeed = 256

export var barrelOffset = Vector2(12, 0)

func _shoot():
	._shoot()
	
	parent.stateMachine.apply_recoil(-recoilSpeed * Vector2(cos(rotation), sin(rotation)))
	create_explosion()

func create_explosion():
	var barrelPosition = Vector2.ZERO
	barrelPosition.x = global_position.x + (barrelOffset.x * cos(rotation) - barrelOffset.y * sin(rotation))
	barrelPosition.y = global_position.y + (barrelOffset.x * sin(rotation) + barrelOffset.y * cos(rotation))
	
	var explosion = explosionScene.instance()
	explosion.position = barrelPosition
	root.add_child(explosion)
