extends Node2D

var item_sword: ToolData = preload("res://resources/tools/sword.tres")

func _ready() -> void:
	
	var sword : GameItem = item_sword.world_item_scene.instantiate()
	sword.setup(item_sword)
	sword.global_position = Vector2(75, -100)
	sword.z_index = 100
	add_child(sword)
