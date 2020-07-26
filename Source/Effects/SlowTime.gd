extends Node

const END_VALUE = 1

var isActive = false
var startTime
var durationMs
var startValue

func start(duration, strength):
	if duration == 0:
		isActive = false
		return
	startTime = OS.get_ticks_msec()
	durationMs = duration * 1000
	startValue = 1 - strength
	Engine.time_scale = startValue
	isActive = true
	
func _ready():
	Engine.time_scale = END_VALUE
	
func _process(_delta):
	if isActive:
		var currentTime = OS.get_ticks_msec() - startTime
		var value = ease_in_circ(currentTime, startValue, END_VALUE, durationMs)
		if currentTime >= durationMs:
			isActive = false
			value = END_VALUE
		Engine.time_scale = value
		
# t: current time
# b: start value
# c: end value
# d: duration
func ease_in_circ(t, b, c, d):
	t /= d;
	return -c * (sqrt(1 - t*t) - 1) + b;

func ease_out_expo(t, b, c, d):	
	return c * ( -pow( 2, -10 * t/d ) + 1 ) + b;
