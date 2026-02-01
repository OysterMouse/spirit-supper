extends Node2D

var item_orange : ItemData = preload("res://resources/items/orange.tres")
var item_banana : ItemData = preload("res://resources/items/banana.tres")
var item_sword: ToolData = preload("res://resources/tools/sword.tres")

func _ready() -> void:
	var orange : GameItem = item_orange.world_item_scene.instantiate()
	orange.setup(item_orange)
	orange.global_position = Vector2(120, 120)
	orange.z_index = 1
	add_child(orange)
	
	var sword : GameItem = item_banana.world_item_scene.instantiate()
	sword.setup(item_sword)
	sword.global_position = Vector2(220, 120)
	sword.z_index = 1
	add_child(sword)
