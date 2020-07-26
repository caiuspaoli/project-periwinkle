extends KinematicBody2D

export var defaultCursorTexture = preload("res://Assets/Crosshair.png")
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

export var maxHealth = 8
var health = 8

export var weapon = preload("res://Source/Weapons/Revolver/Revolver.tscn")
var canShoot = true

onready var stateMachine = $StateMachine
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var camera = $Camera

func _ready():
	weapon = weapon.instance()
	add_child(weapon)
	
	set_cursor()

func _process(_delta):
	update_hud()

func update_hud():
	camera.hud.health.set_text(String(health))
	camera.hud.maxHealth.set_text(String(maxHealth))
	
	camera.hud.x.set_text(String(int(position.x)))
	camera.hud.y.set_text(String(int(position.y)))
	
	camera.hud.ammo.set_text(String(weapon.ammo))
	camera.hud.reserveAmmo.set_text(String(weapon.reserveAmmo))

func set_cursor(texture = defaultCursorTexture):
	var windowScale = Vector2(OS.get_window_size().x / ProjectSettings.get_setting("display/window/size/width"), OS.get_window_size().y / ProjectSettings.get_setting("display/window/size/height"))
	windowScale.x = min(windowScale.x, windowScale.y)
	windowScale.y = windowScale.x
	
	print(windowScale)
	var cursorImage = texture.get_data()
	cursorImage.resize(texture.get_width() * windowScale.x, texture.get_height() * windowScale.y, false)
	cursor.create_from_image(cursorImage)
	Input.set_custom_mouse_cursor(cursor, 0, cursor.get_size() / 2)
	print(cursor)
