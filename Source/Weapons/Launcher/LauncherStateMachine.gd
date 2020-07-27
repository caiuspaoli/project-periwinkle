extends StateMachine

func _ready():
	add_state("idle")
	add_state("cooldown", 0.4, "idle")
	add_state("reload", 2, "idle")
	set_state_id(states.idle.id)
	
	add_buffer("shoot", 0.1, "shoot", ActionTrigger.JUST_PRESSED)
			
func _exit_state_id(_oldStateId, _previousStateId):
	match _oldStateId:
			
		states.reload.id:
			var transfer = min(parent.reserveAmmo, parent.clipSize)
			parent.ammo += transfer
			parent.reserveAmmo -= transfer

func _state_logic(_delta):
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
			
		states.reload.id:
			var mousePosition = parent.get_global_mouse_position()
			parent.rotation = 0
			parent.rotation = parent.get_angle_to(mousePosition)
			parent.sprite.flip_v = mousePosition.x < parent.global_position.x

func _state_transition(_delta):
	match stateId:
		
		states.idle.id:
			if parent.ammo <= 0 and parent.reserveAmmo > 0:
				return states.reload.id
			if parent.get_parent() and parent.get_parent().canShoot and parent.ammo > 0 and use_buffer("shoot"):
				parent.shoot()
				parent.ammo -= 1
				if parent.ammo <= 0:
					return states.reload.id
				else:
					return states.cooldown.id
