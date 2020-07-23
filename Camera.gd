extends Camera2D

export var decay = 0.95
export var maxOffset = Vector2(16, 16)

var trauma = 0.0

onready var chromaticAberrationTimer = $ChromaticAberrationTimer
onready var chromaticAberrationTextureRect = $ChromaticAberrationTextureRect

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	offset.x = maxOffset.x * trauma * rand_range(-1, 1)
	offset.y = maxOffset.y * trauma * rand_range(-1, 1)

func chromaticAberration(duration):
	chromaticAberrationTextureRect.visible = true
	chromaticAberrationTimer.set_wait_time(duration)
	chromaticAberrationTimer.start()

func _on_ChromaticAberrationTimer_timeout():
	chromaticAberrationTextureRect.visible = false
