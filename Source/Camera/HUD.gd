extends MarginContainer

export var font = preload("res://Assets/Fonts/emulogic.tres")

onready var stats = get_node("VBoxContainer/Bottom/Stats")
onready var health = stats.get_node("Health/HealthValue")
onready var maxHealth = stats.get_node("Health/MaxHealthValue")
onready var x = stats.get_node("Position/XValue")
onready var y = stats.get_node("Position/YValue")

onready var weapons = get_node("VBoxContainer/Bottom/Weapons")
onready var allWeapons = weapons.get_node("All")
onready var currentWeapon = weapons.get_node("Current")
onready var ammo = currentWeapon.get_node("AmmoValue")
onready var reserveAmmo = currentWeapon.get_node("ReserveAmmoValue")
