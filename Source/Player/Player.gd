extends KinematicBody2D

var defaultCursorTexture = preload("res://Assets/Crosshair.png")
var cursor = ImageTexture.new()

const TARGET_FPS = 60
var acceleration = 8 * TARGET_FPS
var airAcceleration = 6 * TARGET_FPS
var maxSpeed = 96
var friction = 0.2 * TARGET_FPS
var airResistance = 0.01 * TARGET_FPS
var gravityAcceleration = 8 * TARGET_FPS
var gravitySpeed = 192
var jumpSpeed = 160

var motion = Vector2.ZERO

var maxHealth = 8
var health = 8
var canShoot = true

onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var camera = $Camera

func _ready():
	set_cursor()

func _process(_delta):
	update_hud()

func update_hud():
	camera.hud.health.set_text(String(health))
	camera.hud.maxHealth.set_text(String(maxHealth))
	camera.hud.x.set_text(String(int(position.x)))
	camera.hud.y.set_text(String(int(position.y)))

func set_cursor(texture = defaultCursorTexture):
	var viewportScale = Vector2(get_viewport().size.x / ProjectSettings.get_setting("display/window/size/width"),get_viewport().size.y / ProjectSettings.get_setting("display/window/size/height"))
	print(viewportScale)
	var cursorImage = texture.get_data()
	cursorImage.resize(texture.get_width() * viewportScale.x, texture.get_height() * viewportScale.y, false)
	cursor.create_from_image(cursorImage)
	Input.set_custom_mouse_cursor(cursor)
	print(cursor)
