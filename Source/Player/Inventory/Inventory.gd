extends Node

export(Array, PackedScene) var weaponScenes
var weapons = []
var weaponSprites = []
var currentWeaponIndex

onready var parent = get_parent()

func _ready():
	for weaponScene in weaponScenes:
		var weapon = weaponScene.instance()
		weapons.push_back(weapon)
		var sprite = Sprite.new()
		sprite.texture = weapon.itemTexture
		weaponSprites.push_back(sprite)
		
	if weapons.size() > 0:
		set_weapon(0)

func _input(event):
	for i in range(1, 11):
		if event.is_action_pressed("slot" + String(i)):
			set_weapon(i - 1)
			
	if event.is_action_pressed("scroll_weapons_up"):
		scroll_weapons(-1)
	if event.is_action_pressed("scroll_weapons_down"):
		scroll_weapons(1)
		
func _process(_delta):
	update_weapon_sprites()

func set_weapon(index):
	if index < 0 or index >= weapons.size():
		return
	parent.call_deferred("remove_child", parent.weapon)
	parent.weapon = weapons[index]
	parent.weapon.parent = parent
	parent.call_deferred("add_child", parent.weapon)
	currentWeaponIndex = index
	
func scroll_weapons(offset):
	set_weapon(int(fposmod(currentWeaponIndex + offset, weapons.size())))
	
func update_weapon_sprites():
	if !parent.camera:
		return
	
	for control in parent.camera.hud.allWeapons.get_children():
		parent.camera.hud.allWeapons.call_deferred("remove_child", control)
			
	for i in weaponSprites.size():
		var hBoxContainer = HBoxContainer.new()
		hBoxContainer.alignment = BoxContainer.ALIGN_END
		parent.camera.hud.allWeapons.call_deferred("add_child", hBoxContainer)
		
		var textureRect = TextureRect.new()
		if i == currentWeaponIndex:
			textureRect.texture = load("res://Assets/SelectIndicator.png")
			hBoxContainer.call_deferred("add_child", textureRect)
		
		textureRect = TextureRect.new()
		textureRect.texture = weaponSprites[i].texture
		textureRect.flip_h = true
		hBoxContainer.call_deferred("add_child", textureRect)
		
		var label = Label.new()
		label.text = String(i + 1)
		label.add_font_override("font", parent.camera.hud.font)
		hBoxContainer.call_deferred("add_child", label)
