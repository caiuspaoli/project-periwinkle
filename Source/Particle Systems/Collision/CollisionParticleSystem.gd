extends Node2D

var amount = 0
var point = Vector2.ZERO
var normal = Vector2.ZERO
var color = Color.white

onready var particles = $Particles

func setup(_amount: int, _point: Vector2, _normal: Vector2, _color: Color):
	amount = _amount
	point = _point
	normal = _normal
	color = _color

func _ready():
	particles.emitting = true
	particles.amount = amount
	particles.process_material.direction = Vector3(normal.x, normal.y, 0)
	particles.process_material.color = color
	
	position = point
	
func _on_Timer_timeout():
	queue_free()
