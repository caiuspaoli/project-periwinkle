extends Camera2D

export var targetWeight = 0.2
export var acceleration = 0.025

export var traumaDecay = 0.95
export var maxTraumaOffset = Vector2(16, 16)
var trauma = 0.0

onready var parent = get_parent()
onready var hud = $HUD
onready var chromaticAberrationTimer = $ChromaticAberrationTimer
onready var chromaticAberrationTextureRect = $ChromaticAberrationTextureRect

func _process(_delta):
	var targetPosition = parent.get_local_mouse_position() * targetWeight
	position = lerp(position, targetPosition, acceleration)
	
	if trauma:
		trauma = max(trauma - traumaDecay * _delta, 0)
		shake()

func set_trauma(amount, force = false):
	if force:
		trauma = amount
	else:
		trauma = max(amount, trauma)

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	offset.x = maxTraumaOffset.x * trauma * rand_range(-1, 1)
	offset.y = maxTraumaOffset.y * trauma * rand_range(-1, 1)

func chromatic_aberration(duration):
	chromaticAberrationTextureRect.show()
	chromaticAberrationTimer.set_wait_time(duration)
	chromaticAberrationTimer.start()

func _on_ChromaticAberrationTimer_timeout():
	chromaticAberrationTextureRect.hide()
