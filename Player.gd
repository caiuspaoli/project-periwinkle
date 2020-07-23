extends KinematicBody2D

signal slowTime(duration, strength)

const TARGET_FPS = 60
var ACCELERATION = 8 * TARGET_FPS
var AIR_ACCELERATION = 4 * TARGET_FPS
var MAX_SPEED = 96
var FRICTION = 0.4 * TARGET_FPS
var AIR_RESISTANCE = 0.1 * TARGET_FPS
var GRAVITY_ACCELERATION = 12 * TARGET_FPS
var GRAVITY_SPEED = 192
var JUMP_SPEED = 160

var motion = Vector2.ZERO

var isJumping = false
var isJumpBuffered = false

var chromaticAberrationShader = preload("res://Shaders/ChromaticAberration.tres")

onready var sprite = $Sprite
onready var camera = $Camera
onready var animationPlayer = $AnimationPlayer
onready var jumpTimer = $JumpTimer
onready var jumpBufferTimer = $JumpBufferTimer
onready var chromaticAberrationTimer = $ChromaticAberrationTimer

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("jump"):
		isJumpBuffered = true
		jumpBufferTimer.start()
		
	if event.is_action_pressed("shoot"):
		emit_signal("slowTime", 0.2, 0.8)
		camera.shake(0.03, 8)
		chromaticAberration(0.03)

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	motion.y += GRAVITY_ACCELERATION * delta
	motion.y = clamp(motion.y, -JUMP_SPEED, GRAVITY_SPEED)
	
	sprite.flip_h = get_global_mouse_position().x < position.x
	
	if is_on_floor():
		if x_input != 0:
			motion.x += x_input * ACCELERATION * delta
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
			if sign(x_input) == int(sprite.flip_h) * 2 - 1:
				animationPlayer.play("RunBackward")
			else:
				animationPlayer.play("RunForward")
		else:
			motion.x = lerp(motion.x, 0, FRICTION * delta)
			animationPlayer.play("Idle")
		
		isJumping = false
		if isJumpBuffered:
			jump()
	else:
		if x_input != 0:
			motion.x += x_input * AIR_ACCELERATION * delta
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		else:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta)
			
		if isJumping:
			if Input.is_action_pressed("jump"):
				motion.y = -JUMP_SPEED
			else:
				isJumping = false
				jumpTimer.stop()
		
		if motion.y < 0:
			animationPlayer.play("Jump")
		else:
			animationPlayer.play("Fall")
	
	motion = move_and_slide(motion, Vector2.UP)
	
func chromaticAberration(duration = 0.2):
	sprite.set_material(chromaticAberrationShader)
	chromaticAberrationTimer.set_wait_time(duration)
	chromaticAberrationTimer.start()
	
func jump():
	motion.y = -JUMP_SPEED
	isJumping = true
	jumpTimer.start()
	isJumpBuffered = false
	jumpBufferTimer.stop()
	
func _on_JumpTimer_timeout():
	isJumping = false
	
func _on_JumpBufferTimer_timeout():
	isJumpBuffered = false


func _on_ChromaticAberrationTimer_timeout():
	sprite.set_material(null)
