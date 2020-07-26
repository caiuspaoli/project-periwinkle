extends Timer
class_name KeyedTimer

signal keyedTimeout(key)

var key setget set_key

func _ready():
	self.connect("timeout", self, "_on_self_Timeout")
	
func set_key(value):
	key = value
	
func _on_self_Timeout():
	emit_signal("keyedTimeout", key)
