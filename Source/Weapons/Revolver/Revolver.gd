extends Node2D

var collisionParticleSystem = preload("res://Source/Particle Systems/Collision/CollisionParticleSystem.tscn")

export var barrelOffset = Vector2(13, 0)
export var barrelParticlesColor = Color.yellow
export var barrelParticlesAmount = 1
export var collisionParticlesColor = Color.white
export var collisionParticlesAmount = 4

export var screenShakeTrauma = 0.2
export var chromaticAberrationDuration = 0.05
export var slowTimeDuration = 0.2
export var slowTimeStrength = 0.8

onready var sprite = $Sprite
onready var rayCast = $RayCast
onready var camera = get_parent().get_node("Camera")
onready var slowTime = get_node("/root/World/Effects/SlowTime")

func _ready():
	
	rayCast.add_exception(owner)
	
func _process(delta):
	var mousePosition = get_global_mouse_position()
	
	rotation = 0
	rotation = get_angle_to(mousePosition)
	
	sprite.flip_v = mousePosition.x < global_position.x
	
func shoot():
	if rayCast.is_colliding():
		emit_collision_particles(collisionParticlesAmount, rayCast.get_collision_point(), rayCast.get_collision_normal(), collisionParticlesColor)
	else:
		pass

	var barrelNormal = Vector2(cos(rotation), sin(rotation))
	var barrelPosition = Vector2.ZERO
	barrelPosition.x = global_position.x + (barrelOffset.x * cos(rotation) - barrelOffset.y * sin(rotation))
	barrelPosition.y = global_position.y + (barrelOffset.x * sin(rotation) + barrelOffset.y * cos(rotation))
	emit_collision_particles(barrelParticlesAmount, barrelPosition, barrelNormal, barrelParticlesColor)
	
	camera.set_trauma(screenShakeTrauma)
	camera.chromatic_aberration(chromaticAberrationDuration)
	slowTime.start(slowTimeDuration, slowTimeStrength)

func emit_collision_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = collisionParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	get_tree().root.add_child(particles)


func _on_Player_shoot():
	shoot()
