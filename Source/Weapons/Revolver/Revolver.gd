extends Node2D

var collisionParticleSystem = preload("res://Source/Particle Systems/Collision/CollisionParticleSystem.tscn")

export var barrelOffset = Vector2(13, 0)
export var barrelParticlesColor = Color.yellow
export var barrelParticlesAmount = 2
export var collisionParticlesColor = Color.white
export var collisionParticlesAmount = 5

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

func emit_collision_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = collisionParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	get_tree().root.add_child(particles)
