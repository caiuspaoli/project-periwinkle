extends KinematicBody2D

signal shoot()

const TARGET_FPS = 60
var acceleration = 8 * TARGET_FPS
var airAcceleration = 4 * TARGET_FPS
var maxSpeed = 96
var friction = 0.4 * TARGET_FPS
var airResistance = 0.1 * TARGET_FPS
var gravityAcceleration = 12 * TARGET_FPS
var gravitySpeed = 192
var jumpSpeed = 160

var motion = Vector2.ZERO

var isJumping = false
var isJumpBuffered = false

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var jumpTimer = $JumpTimer
onready var jumpBufferTimer = $JumpBufferTimer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("jump"):
		isJumpBuffered = true
		jumpBufferTimer.start()
		
	if event.is_action_pressed("shoot"):
		emit_signal("shoot")

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	motion.y += gravityAcceleration * delta
	motion.y = clamp(motion.y, -jumpSpeed, gravitySpeed)
	
	sprite.flip_h = get_global_mouse_position().x < global_position.x
	
	if is_on_floor():
		if x_input != 0:
			motion.x += x_input * acceleration * delta
			motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
			if sign(x_input) == int(sprite.flip_h) * 2 - 1:
				animationPlayer.play("RunBackward")
			else:
				animationPlayer.play("RunForward")
		else:
			motion.x = lerp(motion.x, 0, friction * delta)
			animationPlayer.play("Idle")
		
		isJumping = false
		if isJumpBuffered:
			jump()
	else:
		if x_input != 0:
			motion.x += x_input * airAcceleration * delta
			motion.x = clamp(motion.x, -maxSpeed, maxSpeed)
		else:
			motion.x = lerp(motion.x, 0, airResistance * delta)
			
		if isJumping:
			if Input.is_action_pressed("jump"):
				motion.y = -jumpSpeed
			else:
				isJumping = false
				jumpTimer.stop()
		
		if motion.y < 0:
			animationPlayer.play("Jump")
		else:
			animationPlayer.play("Fall")
	
	motion = move_and_slide(motion, Vector2.UP)
	
func jump():
	motion.y = -jumpSpeed
	isJumping = true
	jumpTimer.start()
	isJumpBuffered = false
	jumpBufferTimer.stop()
	
func _on_JumpTimer_timeout():
	isJumping = false
	
func _on_JumpBufferTimer_timeout():
	isJumpBuffered = false
