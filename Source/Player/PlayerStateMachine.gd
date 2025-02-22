extends StateMachine

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump", 0.3, "fall")
	add_state("fall")
	set_state_id(states.idle.id)
	
	add_buffer("jump", 0.1, "jump", ActionTrigger.JUST_PRESSED)

func _state_logic(_delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	match stateId:
		
		states.idle.id:
			parent.canShoot = true
			
			parent.motion.x = lerp(parent.motion.x, 0, parent.friction * _delta)
			parent.animationPlayer.play("Idle")
			parent.sprite.flip_h = parent.get_global_mouse_position().x < parent.global_position.x
		
		states.run.id:
			parent.canShoot = true
			
			parent.motion.x += x_input * parent.acceleration * _delta
			parent.motion.x = clamp(parent.motion.x, -parent.maxSpeed, parent.maxSpeed)
			
			if sign(x_input) == int(parent.sprite.flip_h) * 2 - 1:
				parent.animationPlayer.play("RunBackward")
			else:
				parent.animationPlayer.play("RunForward")
			parent.sprite.flip_h = parent.get_global_mouse_position().x < parent.global_position.x
		
		states.jump.id:
			parent.canShoot = true
			
			if x_input == 0:
				parent.motion.x = lerp(parent.motion.x, 0, parent.airResistance * _delta)
			else:
				if abs(parent.motion.x) <= parent.maxSpeed:
					parent.motion.x += x_input * parent.airAcceleration * _delta
					parent.motion.x = clamp(parent.motion.x, -parent.maxSpeed, parent.maxSpeed)
				elif sign(x_input) != sign(parent.motion.x):
					parent.motion.x += x_input * parent.airAcceleration * _delta
			parent.motion.y = -parent.jumpSpeed
			
			parent.animationPlayer.play("Jump")
			parent.sprite.flip_h = parent.get_global_mouse_position().x < parent.global_position.x
		
		states.fall.id:
			parent.canShoot = true
			
			if x_input == 0:
				parent.motion.x = lerp(parent.motion.x, 0, parent.airResistance * _delta)
			else:
				if abs(parent.motion.x) <= parent.maxSpeed:
					parent.motion.x += x_input * parent.airAcceleration * _delta
					parent.motion.x = clamp(parent.motion.x, -parent.maxSpeed, parent.maxSpeed)
				elif sign(x_input) != sign(parent.motion.x):
					parent.motion.x += x_input * parent.airAcceleration * _delta
			parent.motion.y += parent.gravityAcceleration * _delta
			if parent.motion.y <= parent.gravitySpeed:
				parent.motion.y = min(parent.motion.y, parent.gravitySpeed)
			
			if parent.motion.y < 0:
				parent.animationPlayer.play("Jump")
			else:
				parent.animationPlayer.play("Fall")
			parent.sprite.flip_h = parent.get_global_mouse_position().x < parent.global_position.x
	
	parent.motion = parent.move_and_slide(parent.motion, Vector2.UP)

func _state_transition(_delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	match stateId:
		
		states.idle.id:
			if x_input != 0:
				return states.run.id
			if use_buffer("jump"):
				return states.jump.id
			if !parent.test_move(parent.transform, Vector2.DOWN):
				return states.fall.id
		
		states.run.id:
			if x_input == 0:
				return states.idle.id
			if use_buffer("jump"):
				return states.jump.id
			if !parent.test_move(parent.transform, Vector2.DOWN):
				return states.fall.id
		
		states.jump.id:
			if !Input.is_action_pressed("jump"):
				return states.fall.id
		
		states.fall.id:
			if parent.test_move(parent.transform, Vector2.DOWN):
				if x_input == 0:
					return states.idle.id
				else:
					return states.run.id

func apply_recoil(recoil):
	parent.motion = recoil
	set_state_id(states.fall.id)
	
func apply_damage(damage):
	parent.health = max(0, parent.health - damage)
