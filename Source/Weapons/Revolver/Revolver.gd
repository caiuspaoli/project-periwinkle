extends Weapon

var barrelParticleSystem = preload("res://Source/Particle Systems/CollisionParticleSystem.tscn")
var collisionParticleSystem = preload("res://Source/Particle Systems/CollisionParticleSystem.tscn")

var tracerSystem = preload("res://Source/Tracer Systems/LineTracerSystem.tscn")

export var barrelOffset = Vector2(13, 0)
export var barrelParticlesColor = Color(1, 1, 0, 1)
export var barrelParticlesAmount = 2

export var collisionParticlesColor = Color.white
export var collisionParticlesAmount = 5

export var tracerDuration = 0.3
export var tracerColor = Color(1, 1, 0, 0.4)

onready var rayCast = $RayCast

func _ready():
	var node = parent
	while (node):
		rayCast.add_exception(parent)
		node = node.get_parent()

func _shoot():
	._shoot()
	emit_effects()

func emit_effects():
	var barrelNormal = Vector2(cos(rotation), sin(rotation))
	var barrelPosition = Vector2.ZERO
	barrelPosition.x = global_position.x + (barrelOffset.x * cos(rotation) - barrelOffset.y * sin(rotation))
	barrelPosition.y = global_position.y + (barrelOffset.x * sin(rotation) + barrelOffset.y * cos(rotation))
	emit_barrel_particles(barrelParticlesAmount, barrelPosition, barrelNormal, barrelParticlesColor)
	
	var endPoint
	if rayCast.is_colliding():
		emit_collision_particles(collisionParticlesAmount, rayCast.get_collision_point(), rayCast.get_collision_normal(), collisionParticlesColor)
		endPoint = rayCast.get_collision_point()
	else:
		endPoint = rayCast.global_position + rayCast.get_cast_to()
	emit_tracer(barrelPosition, rayCast.global_transform.origin.distance_to(endPoint) - rayCast.global_transform.origin.distance_to(barrelPosition), rotation, tracerDuration, tracerColor)

func emit_barrel_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = barrelParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	root.add_child(particles)

func emit_collision_particles(amount: int, point: Vector2, normal: Vector2, color: Color):
	var particles = collisionParticleSystem.instance()
	particles.setup(amount, point, normal, color)
	root.add_child(particles)

func emit_tracer(point: Vector2, length: float, angle: float, duration: float, color: Color):
	var tracer = tracerSystem.instance()
	tracer.setup(point, length, angle, duration, color)
	root.add_child(tracer)
