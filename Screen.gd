extends Node

onready var root = get_tree().root
onready var baseSize = root.size

func _ready():
	get_tree().connect("screen_resized", self, "_on_screen_resized")
	
	root.set_size_override_stretch(false)
	root.set_size_override(false, Vector2.ZERO)
	root.set_as_render_target(true)
	root.set_render_target_update_mode(root.RENDER_TARGET_UPDATE_ALWAYS)
	root.set_render_target_to_screen_rect(root.get_rect())

func _on_screen_resized():
	var newWindowSize = OS.get_window_size()
	OS.set_window_size(Vector2(max(baseSize.x, newWindowSize.x), max(baseSize.y, newWindowSize.y)))
	
	var scaleX = max(int(newWindowSize.x / baseSize.x), 1)
	var scaleY = max(int(newWindowSize.y / baseSize.y), 1)
	var scale = min(scaleX, scaleY)
	
	var difference = newWindowSize - (baseSize * scale)
	
	root.set_rect(Rect2(Vector2(), baseSize))
	root.set_render_target_to_screen_rect(Rect2((difference / 2).floor(), baseSize * scale))

