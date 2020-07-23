extends KinematicBody2D

const TARGET_FPS = 60
const ACCELERATION = 12
const AIR_ACCELERATION = 6
const MAX_SPEED = 96
const FRICTION = 0.4
const AIR_RESISTANCE = 0.1
const GRAVITY = 12
const JUMP_SPEED = 160
const JUMP_TIME = 0.3
const JUMP_BUFFER_TIME = 0.1

var motion = Vector2.ZERO

var isJumping = false
var jumpTimer = null

var isJumpBuffered = false
var jumpBufferTimer = null

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _ready():
	jumpTimer = Timer.new()
	jumpTimer.set_one_shot(true)
	jumpTimer.set_wait_time(JUMP_TIME)
	jumpTimer.connect("timeout", self, "on_jumpTimer_timeout")
	add_child(jumpTimer)
	
	jumpBufferTimer = Timer.new()
	jumpBufferTimer.set_one_shot(true)
	jumpBufferTimer.set_wait_time(JUMP_BUFFER_TIME)
	jumpBufferTimer.connect("timeout", self, "on_jumpBufferTimer_timeout")
	add_child(jumpBufferTimer)

func _input(event):
	if event.is_action_pressed("ui_up"):
		isJumpBuffered = true
		jumpBufferTimer.start()

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y += GRAVITY * delta * TARGET_FPS
	
	if is_on_floor():
		if x_input != 0:
			motion.x += x_input * ACCELERATION * delta * TARGET_FPS
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
			sprite.flip_h = x_input < 0
			animationPlayer.play("Run")
		else:
			motion.x = lerp(motion.x, 0, FRICTION * delta * TARGET_FPS)
			animationPlayer.play("Idle")
		
		isJumping = false
		if isJumpBuffered:
			motion.y = -JUMP_SPEED
			isJumping = true
			jumpTimer.start()
			isJumpBuffered = false
			jumpBufferTimer.stop()
	else:
		if x_input != 0:
			motion.x += x_input * AIR_ACCELERATION * delta * TARGET_FPS
			motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
			sprite.flip_h = x_input < 0
		else:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE * delta * TARGET_FPS)
			
		if isJumping:
			if Input.is_action_pressed("ui_up"):
				motion.y = -JUMP_SPEED
				animationPlayer.play("Jump")
			else:
				isJumping = false
				jumpTimer.stop()
	
	motion = move_and_slide(motion, Vector2.UP)
	
func on_jumpTimer_timeout():
	isJumping = false
	
func on_jumpBufferTimer_timeout():
	isJumpBuffered = false
