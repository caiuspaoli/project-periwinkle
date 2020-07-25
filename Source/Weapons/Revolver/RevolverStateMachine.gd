extends StateMachine

func _ready():
	add_state("idle")
	add_state("cooldown", 0.3, "idle")
	set_state_id(states.idle.id)
	
	add_buffer("shoot", 0.1, "shoot", ActionTrigger.JUST_PRESSED)
	
func _enter_state_id(newStateId, previousStateId):
	match newStateId:
		
		states.cooldown.id:
			if parent.rayCast.is_colliding():
				parent.emit_collision_particles(parent.collisionParticlesAmount, parent.rayCast.get_collision_point(), parent.rayCast.get_collision_normal(), parent.collisionParticlesColor)
			else:
				pass
		
			var barrelNormal = Vector2(cos(parent.rotation), sin(parent.rotation))
			var barrelPosition = Vector2.ZERO
			barrelPosition.x = parent.global_position.x + (parent.barrelOffset.x * cos(parent.rotation) - parent.barrelOffset.y * sin(parent.rotation))
			barrelPosition.y = parent.global_position.y + (parent.barrelOffset.x * sin(parent.rotation) + parent.barrelOffset.y * cos(parent.rotation))
			parent.emit_collision_particles(parent.barrelParticlesAmount, barrelPosition, barrelNormal, parent.barrelParticlesColor)
			
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
