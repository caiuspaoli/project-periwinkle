extends StateMachine

func _ready():
	add_state("idle")
	add_state("cooldown", 0.2, "idle")
	set_state_id(states.idle.id)
	
	add_buffer("shoot", 0.1, "shoot", ActionTrigger.JUST_PRESSED)
	
func _enter_state_id(newStateId, previousStateId):
	match newStateId:
		
		states.cooldown.id:
			parent.emit_effects()
			parent.camera.set_trauma(parent.screenShakeTrauma)
			parent.camera.chromatic_aberration(parent.chromaticAberrationDuration)
			parent.slowTime.start(parent.slowTimeDuration, parent.slowTimeStrength)
	
func _state_logic(delta):
	match stateId:
		
		states.idle.id:
			var mousePosition = parent.get_global_mouse_position()
			parent.rotation = 0
			parent.rotation = parent.get_angle_to(mousePosition)
			parent.sprite.flip_v = mousePosition.x < parent.global_position.x
			
		states.cooldown.id:
			var mousePosition = parent.get_global_mouse_position()
			parent.rotation = 0
			parent.rotation = parent.get_angle_to(mousePosition)
			parent.sprite.flip_v = mousePosition.x < parent.global_position.x
			
func _state_transition(delta):
	match stateId:
		
		states.idle.id:
			if parent.get_parent() and parent.get_parent().canShoot and use_buffer("shoot"):
				return states.cooldown.id
