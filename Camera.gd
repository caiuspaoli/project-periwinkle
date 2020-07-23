extends Camera2D

const DAMP_EASING = 1.0

var amplitude = 0
var isShaking = false

onready var screenShakeTimer = $ScreenShakeTimer

func _process(delta):
	if isShaking:
		var damping = ease(screenShakeTimer.get_time_left() / screenShakeTimer.get_wait_time(), DAMP_EASING)
		offset = Vector2(rand_range(-amplitude, amplitude) * damping, rand_range(-amplitude, amplitude) * damping)

func shake(duration = 0.4, amplitude = 0.4):
	isShaking = true
	
	self.amplitude = amplitude
	screenShakeTimer.set_wait_time(duration)
	screenShakeTimer.start()


func _on_ScreenShakeTimer_timeout():
	isShaking = false
	amplitude = 0
