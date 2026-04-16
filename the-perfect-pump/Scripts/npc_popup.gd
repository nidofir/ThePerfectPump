extends Node3D

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("toggle npc sprites"):
		_on_Arrow_pressed()
		#print("new character")
	
@onready var car: Node3D = $Car


@onready var npc_sprite: Sprite3D = $NPC_sprite
 

var new_texture = [
	load("res://Assets/Sprites/Character_1.png"),
	load("res://Assets/Sprites/Character_2.png"),
	load("res://Assets/Sprites/Character_3.png"),
	load("res://Assets/Sprites/Character_4.png"),
	load("res://Assets/Sprites/Character_5.png"),
	load("res://Assets/Sprites/Character_6.png"),
	load("res://Assets/Sprites/Character_7.png"),
	load("res://Assets/Sprites/Character_8.png"),
	load("res://Assets/Sprites/Character_9.png"),
	load("res://Assets/Sprites/Character_10.png"),
	load("res://Assets/Sprites/Character_11.png"),
	load("res://Assets/Sprites/Character_12.png"),
	load("res://Assets/Sprites/Character_13.png"),
	load("res://Assets/Sprites/Character_14.png"),
	load("res://Assets/Sprites/Character_15.png")
	]

var texture_index := 0

func _on_Arrow_pressed() -> void:
	npc_sprite.texture = new_texture[texture_index]
	texture_index += 1
	if texture_index == new_texture.size():
		texture_index = 0
	#print("new character")
	
