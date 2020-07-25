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

var canShoot = true
var isJumping = false

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var jumpTimer = $PlayerStateMachine.get_node("JumpTimer")

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("shoot"):
		emit_signal("shoot")

func _physics_process(delta):
	pass
	
func jump():
	motion.y = -jumpSpeed
	isJumping = true
	jumpTimer.start()
