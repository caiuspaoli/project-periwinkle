extends StateMachine
class_name WeaponStateMachine

func _ready():
	add_state("idle")
	add_state("cooldown", parent.cooldownTime, "idle")
	add_state("reload", parent.reloadTime, "idle")
	set_state_id(states.idle.id)
	
	add_buffer("shoot", 0.1, "shoot", ActionTrigger.JUST_PRESSED)
	add_buffer("reload", 0.1, "reload", ActionTrigger.JUST_PRESSED)
			
func _exit_state_id(_oldStateId, _previousStateId):
	match _oldStateId:
			
		states.reload.id:
			var transfer = min(parent.clipSize - parent.ammo, parent.reserveAmmo)
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
			if use_buffer("shoot"):
				if parent.get_parent() and parent.get_parent().canShoot and parent.ammo > 0:
					parent._shoot()
					parent.ammo -= 1
					if parent.ammo > 0:
						return states.cooldown.id
					else:
						return states.reload.id
				elif parent.ammo <= 0:
					parent.soundFxController.play(parent.failSound)
				
			if parent.ammo < parent.clipSize and use_buffer("reload"):
				return states.reload.id
				
		states.reload.id:
			if use_buffer("shoot"):
				parent.soundFxController.play(parent.failSound)
