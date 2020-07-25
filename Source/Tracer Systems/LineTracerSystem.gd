extends Node2D
class_name LineTracerSystem

const END_ALPHA = -1

var point = Vector2.ZERO
var length = 0.0
var angle = 0
var duration = 1.0
var color = Color.white

var startTime
var durationMs
var startAlpha

onready var sprite = $Sprite
onready var timer = $Timer

func setup(_point: Vector2, _length: float, _angle: float, _duration: float, _color: Color):
	point = _point
	length = _length
	angle = _angle
	duration = _duration
	color = _color
	
func _ready():
	position = point
	sprite.region_rect.end.x = length + 1
	rotation = angle
	sprite.modulate = color
	timer.set_wait_time(duration)
	timer.start()
	
	startTime = OS.get_ticks_msec()
	durationMs = duration * 1000
	startAlpha = color.a
	
func _process(delta):
	sprite.modulate = Color(color.r, color.g, color.b, ease_in_circ(OS.get_ticks_msec() - startTime, startAlpha, END_ALPHA, durationMs))
	
func _on_Timer_timeout():
	queue_free()
	
# t: current time
# b: start value
# c: end value
# d: duration
func ease_in_circ(t, b, c, d):
	t /= d;
	return -c * (sqrt(1 - t*t) - 1) + b;
