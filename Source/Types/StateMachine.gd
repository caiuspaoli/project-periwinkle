extends Node
class_name StateMachine

var stateId setget set_state_id
var previousStateId

var states = {}
var buffers = {}

enum ActionTrigger {
	PRESSED,
	RELEASED,
	JUST_PRESSED,
	JUST_RELEASED
}

onready var parent = get_parent()

func _input(event):
	for i in buffers:
		match buffers[i].trigger:
			
			ActionTrigger.PRESSED:
				if event.is_action_pressed(buffers[i].action):
					buffers[i].buffered = true
					buffers[i].timer.stop()
				elif event.is_action_released(buffers[i].action):
					buffers[i].timer.start()
					
			ActionTrigger.RELEASED:
				if event.is_action_released(buffers[i].action):
					buffers[i].buffered = true
					buffers[i].timer.stop()
				elif event.is_action_pressed(buffers[i].action):
					buffers[i].timer.start()
					
			ActionTrigger.JUST_PRESSED:
				if event.is_action_pressed(buffers[i].action):
					buffers[i].buffered = true
					buffers[i].timer.start()
					
			ActionTrigger.JUST_RELEASED:
				if event.is_action_released(buffers[i].action):
					buffers[i].buffered = true
					buffers[i].timer.start()

func _physics_process(delta):
	if stateId != null:
		_state_logic(delta)
		var transition = _state_transition(delta)
		if transition != null:
			set_state_id(transition)

func _state_logic(delta):
	pass
	
func _state_transition(delta):
	return null
	
func _enter_state_id(newStateId, oldStateId):
	pass
	
func _exit_state_id(oldStateId, newStateId):
	pass
	
func set_state_id(newStateId):
	previousStateId = stateId
	stateId = newStateId
	
	for key in states:
		if states[key].id != previousStateId:
			continue
		
		if previousStateId:
			if states[key].timer:
				states[key].timer.stop()
			_exit_state_id(previousStateId, stateId)
			
	for key in states:
		if states[key].id != stateId:
			continue
		
		if states[key].timer:
			states[key].timer.start()
		_enter_state_id(stateId, previousStateId)
	
func add_state(key, duration = null, fallbackKey = null):
	var timer = null
	if duration:
		timer = KeyedTimer.new()
		timer.set_key(key)
		timer.set_one_shot(true)
		timer.set_wait_time(duration)
		add_child(timer)
		timer.connect("keyedTimeout", self, "_on_state_timeout")
	
	states[key] = {
		"id": states.size(),
		"timer": timer,
		"fallbackKey": fallbackKey,
	}

func add_buffer(key, duration, action, trigger):
	var timer = KeyedTimer.new()
	timer.set_key(key)
	timer.set_one_shot(true)
	timer.set_wait_time(duration)
	add_child(timer)
	timer.connect("keyedTimeout", self, "_on_buffer_timeout")
	
	buffers[key] = {
		"buffered": trigger == ActionTrigger.RELEASED,
		"action": action,
		"trigger": trigger,
		"timer": timer,
	}
	
func use_buffer(key):
	if !buffers[key].buffered:
		buffers[key].timer.stop()
		return false
	
	buffers[key].buffered = false
	match buffers[key].trigger:
		ActionTrigger.PRESSED:
			buffers[key].buffered = Input.is_action_pressed(key)
		ActionTrigger.RELEASED:
			buffers[key].buffered = !Input.is_action_pressed(key)
	
	return true

func _on_state_timeout(key):
	if states[key].fallbackKey:
		set_state_id(states[states[key].fallbackKey].id)
	else:
		set_state_id(previousStateId)

func _on_buffer_timeout(key):
	buffers[key].buffered = false
