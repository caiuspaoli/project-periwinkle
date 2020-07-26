extends MarginContainer

onready var stats = get_node("VBoxContainer/Bottom/Stats")
onready var health = stats.get_node("Health/HealthValue")
onready var maxHealth = stats.get_node("Health/MaxHealthValue")
onready var x = stats.get_node("Position/XValue")
onready var y = stats.get_node("Position/YValue")
